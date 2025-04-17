locals {
  name = "${var.project_name}-mgmt"
}

########################
# Optionally create repo
########################

# GitHub Resources

resource "github_repository" "mgmt_repository" {
  count = var.gh_create_vcs_repo ? 1 : 0

  name                        = var.gh_repo_name == null ? local.name : var.gh_repo_name
  description                 = "Management repository for ${var.project_name}"
  visibility                  = var.gh_repo_visibility
  allow_merge_commit          = var.gh_repo_allow_merge_commit
  allow_rebase_merge          = var.gh_repo_allow_rebase_merge
  allow_squash_merge          = var.gh_repo_allow_squash_merge
  delete_branch_on_merge      = var.gh_repo_delete_branch_on_merge
  has_issues                  = var.gh_repo_has_issues
  has_projects                = var.gh_repo_has_projects
  has_wiki                    = var.gh_repo_has_wiki
  vulnerability_alerts        = var.gh_repo_vulnerability_alerts
  web_commit_signoff_required = var.gh_repo_web_commit_signoff_required
  topics                      = var.gh_repo_topics
  dynamic "template" {
    for_each = var.gh_repo_template_repo == null ? toset([]) : toset([var.gh_repo_template_repo])

    content {
      owner                = var.gh_repo_template_owner
      repository           = var.gh_repo_template_repo
      include_all_branches = var.gh_repo_template_include_all_branches
    }
  }
}
# TFE Resources

resource "tfe_project" "landing_zone" {
  name         = var.project_name
  organization = var.organization
}

resource "tfe_team" "landing_zone" {
  name         = var.team_name
  organization = var.organization
  visibility   = var.team_visibility
  sso_team_id  = var.team_sso_team_id
}

resource "tfe_team_project_access" "landing_zone" {
  access     = var.project_team_access
  team_id    = tfe_team.landing_zone.id
  project_id = tfe_project.landing_zone.id
}

resource "tfe_team_token" "landing_zone" {
  team_id = tfe_team.landing_zone.id
}

resource "tfe_workspace" "landing_zone_mgmt" {
  name         = local.name
  organization = var.organization
  project_id   = tfe_project.landing_zone.id

  auto_apply                    = var.workspace_auto_apply
  assessments_enabled           = var.workspace_assessment_enabled
  structured_run_output_enabled = var.workspace_structured_run_output_enabled
  terraform_version             = var.workspace_terraform_version
  force_delete                  = var.workspace_force_delete

  dynamic "vcs_repo" {
    for_each = var.gh_create_vcs_repo ? toset([true]) : toset([])
    content {
      identifier                 = github_repository.mgmt_repository[0].full_name
      ingress_submodules         = var.workspace_vcs_ingress_submodules
      branch                     = var.workspace_vcs_repo_branch
      oauth_token_id             = var.gh_oauth_token_id
      github_app_installation_id = var.gh_app_id
    }
  }
}

resource "tfe_variable" "team_token" {
  key          = "TFE_TOKEN"
  value        = tfe_team_token.landing_zone.token
  category     = "env"
  sensitive    = true
  workspace_id = tfe_workspace.landing_zone_mgmt.id
  description  = "TFE Team Token created by terraform-tfe-platform-management. Used for managing HCP TF resources (workspaces, variables, etc)."
}
