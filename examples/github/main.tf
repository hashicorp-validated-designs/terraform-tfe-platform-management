module "bu_app_lz_example_2" {
  source = "../.."

  organization = var.organization
  project_name = "bu-app-lz-example-2"
  team_name    = "bu-app-lz-example-2"

  # If creating a vcs repo you must also use a template
  # workspaces cannot connect to empty repos
  gh_create_vcs_repo     = true
  gh_app_id              = var.gh_app_id
  gh_repo_template_owner = "drewmullen"
  gh_repo_template_repo  = "terraform-repo-template"

  workspace_force_delete = var.force_delete
}