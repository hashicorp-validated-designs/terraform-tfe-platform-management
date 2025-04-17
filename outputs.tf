output "github_repository_attributes" {
  description = "Attributes of the GitHub repository"
  value       = try(github_repository.mgmt_repository[0], null)
}

output "tfe_project_attributes" {
  description = "Attributes of the TFE Project"
  value       = tfe_project.landing_zone
}

output "tfe_workspace_attributes" {
  description = "Attributes of the TFE Workspace"
  value       = tfe_workspace.landing_zone_mgmt
}

output "tfe_team_attributes" {
  description = "Attributes of the TFE Team"
  value       = tfe_team.landing_zone
}