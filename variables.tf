# HCP Terraform Variables

variable "organization" {
  type        = string
  description = "The name of your HCP Terraform or Terraform Enterprise organization."
}

variable "project_name" {
  type        = string
  description = "The name of the project to create."
}

variable "team_name" {
  type        = string
  description = "The name of the team to create. This team is to be associated with the project."
}

variable "team_sso_team_id" {
  type        = string
  description = "(Optional) The SSO team ID to associate with the team. To pair with SSO must either provide the IDP ID for team or match the `team_name` to IDP name."
  default     = null
}

variable "team_visibility" {
  type        = string
  description = "The visibility of the team to create. Valid values are `secret` or `organization`."
  default     = "secret"

  validation {
    condition     = var.team_visibility == "secret" || var.team_visibility == "organization"
    error_message = "Valid values are 'secret' or 'organization'."
  }
}

variable "project_team_access" {
  type        = string
  description = "The permission set the team should have on the project. Valid values are `read`, `write`, `maintain`, or `admin`."
  default     = "maintain"

  validation {
    condition     = contains(["read", "write", "maintain", "admin"], var.project_team_access)
    error_message = "Valid values are `read`, `write`, `maintain`, or `admin`."
  }
}

variable "workspace_auto_apply" {
  type        = bool
  description = "Whether to automatically apply changes to the workspace."
  default     = true
}

variable "workspace_assessment_enabled" {
  type        = bool
  description = "Whether to enable health checks for the workspace."
  default     = true
}

variable "workspace_structured_run_output_enabled" {
  type        = bool
  description = "Whether to enable structured run output for the workspace."
  default     = false
}

variable "workspace_terraform_version" {
  type        = string
  description = "The version of Terraform to use for the workspace. Default of `null` will use latest version at workspace creation point in time."
  default     = null
}

variable "workspace_vcs_repo_branch" {
  description = "The branch to use for WS VCS repo"
  type        = string
  default     = "main"
}

variable "workspace_vcs_ingress_submodules" {
  description = "Ingress submodules field for TFE Workspace VCS settings"
  type        = bool
  default     = false
}

variable "workspace_force_delete" {
  description = "Whether to force delete the workspace."
  type        = bool
  default     = false
}

# GitHub Variables

variable "gh_app_id" {
  description = "The ID of the GH VCS provider application. Required if `gh_create_vcs_repo` is true."
  type        = string
  default     = null
}

variable "gh_oauth_token_id" {
  description = "The ID of the GH VCS provider OAuth token. Required if `gh_create_vcs_repo` is true."
  type        = string
  default     = null
}

# Cannot use variable validation because you have to check both oauth and gh_app which creates a circular dependency
check "vcs_settings" {
  assert {
    condition     = var.gh_create_vcs_repo == true ? anytrue([var.gh_app_id != null, var.gh_oauth_token_id != null]) : true
    error_message = "Either `gh_oauth_token_id` or `gh_app_id` variable is required when `gh_create_vcs_repo` is true. Otherwise it should be set to `null`."
  }
}

variable "gh_repo_description" {
  description = "The description of the repository"
  type        = string
  default     = null
}

variable "gh_repo_name" {
  description = "The name of the repository to create."
  type        = string
  default     = null
}

variable "gh_create_vcs_repo" {
  type        = bool
  description = "Whether to create a GitHub VCS repository for the project."
  default     = false
}

variable "gh_repo_visibility" {
  description = "The visibility of the repository"
  type        = string
  default     = "private"
}

variable "gh_repo_allow_merge_commit" {
  description = "Allow merge commits"
  type        = bool
  default     = true
}

variable "gh_repo_allow_rebase_merge" {
  description = "Allow rebase merges"
  type        = bool
  default     = true
}

variable "gh_repo_allow_squash_merge" {
  description = "Allow squash merges"
  type        = bool
  default     = true
}

variable "gh_repo_delete_branch_on_merge" {
  description = "Delete branch on merge"
  type        = bool
  default     = true
}

variable "gh_repo_has_issues" {
  description = "Enable issues"
  type        = bool
  default     = true
}

variable "gh_repo_has_projects" {
  description = "Enable projects"
  type        = bool
  default     = false
}

variable "gh_repo_has_wiki" {
  description = "Enable wiki"
  type        = bool
  default     = false
}

variable "gh_repo_vulnerability_alerts" {
  description = "Enable vulnerability alerts"
  type        = bool
  default     = true
}

variable "gh_repo_web_commit_signoff_required" {
  description = "Require web commit signoff"
  type        = bool
  default     = true
}

variable "gh_repo_topics" {
  description = "Repository topics"
  type        = list(string)
  default     = []
}

variable "gh_repo_template_include_all_branches" {
  description = "Include all branches in the template"
  type        = bool
  default     = false
}

variable "gh_repo_template_owner" {
  description = "The owner of the repository to use as a template."
  type        = string
  default     = null
}

variable "gh_repo_template_repo" {
  description = "The name of the repository to use as a template."
  type        = string
  default     = null
}
