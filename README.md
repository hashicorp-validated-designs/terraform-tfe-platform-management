# terraform-tfe-platform-management

This repo is intended to provide prescriptive guidance and automation on how to accelerate the configuration of your HCP Terraform organization for usage with landing zones. 

In this guide we will review the prerequisites for setting up your HCP Terraform organization for the Landing Zone (LZ) process. Once completed, you'll be able to use this module to deploy "management" workspaces as defined in the HVD operating Terraform guide.

This module deploys:
- HCP TF Project for organizing a teams workspaces 
- HCP TF Team with access to manage the project (`maintain` by default)
- HCP TF Workspace for managing workspaces
- (Optional) GitHub repository to use as the management workspaces VCS backing repo
- Team token attached to the HCP TF Workspace


All variables in this module are prefixed with the resource they are passed to. For example, `gh_` variables are passed to GitHub repo resource, `workspace_` are passed to the `tfe_workspace`, etc.

## Prerequisites

These steps are to be performed in the HCP Terraform UI as part of your initial setup before deploying this module.

1. Configure VCS integration with your supported VCS.
2. Confifgure SAML/SSO with your supported identity provider.
3. Create your first "admin" team to represent the platform team, or the HCP Terraform admins. The team name should be something along the lines of `tf-platform-team` or `tf-admins`(TBD). This team should have full access at the organization level.
4. Create your first project that will be used to manage the configuration of the rest of your HCP Terraform organization as code. The project name should be something along the lines of `platform-team-mgmt` (TBD).
5. Create a workspace within the project that will manage the configuration of your organization. The workspace name should be `hcptf-top-level-mgmt` (TBD).

## Usage

For each project landing zone that you want to deploy, simply add a module block into your configuration with the appropriate input values set, as per the example below:


### With Github repo and VCS backed workspace:
_Note: when you create a workspace with a repo, the repo must not be empty. In this module we require sourcing a GitHub repo template to circumvent and to encourage common practices via templates_
```hcl
module "bu_app_lz_example_2" {
  source = "hashicorp/hvd-accelerator/tfe"

  organization = var.organization
  project_name = "bu-app-lz-example-2"
  team_name    = "bu-app-lz-example-2"
  
  gh_create_vcs_repo     = true
  gh_app_id              = var.gh_app_id
  gh_repo_template_owner = "drewmullen"
  gh_repo_template_repo  = "terraform-repo-template"
}
```

### Without a GitHub repo and VCS backed workspace:
```hcl
module "bu_app_lz_example_1" {
  source = "hashicorp/hvd-accelerator/tfe"

  organization = var.organization
  project_name = "bu-app-lz-example-1"
  team_name    = "bu-app-lz-example-1"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.64 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 6.6.0 |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.64.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_repository.mgmt_repository](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository) | resource |
| [tfe_project.landing_zone](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/project) | resource |
| [tfe_team.landing_zone](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/team) | resource |
| [tfe_team_project_access.landing_zone](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/team_project_access) | resource |
| [tfe_team_token.landing_zone](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/team_token) | resource |
| [tfe_variable.team_token](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_workspace.landing_zone_mgmt](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_organization"></a> [organization](#input\_organization) | The name of your HCP Terraform or Terraform Enterprise organization. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project to create. | `string` | n/a | yes |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | The name of the team to create. This team is to be associated with the project. | `string` | n/a | yes |
| <a name="input_gh_app_id"></a> [gh\_app\_id](#input\_gh\_app\_id) | The ID of the GH VCS provider application. Required if `gh_create_vcs_repo` is true. | `string` | `null` | no |
| <a name="input_gh_create_vcs_repo"></a> [gh\_create\_vcs\_repo](#input\_gh\_create\_vcs\_repo) | Whether to create a GitHub VCS repository for the project. | `bool` | `false` | no |
| <a name="input_gh_oauth_token_id"></a> [gh\_oauth\_token\_id](#input\_gh\_oauth\_token\_id) | The ID of the GH VCS provider OAuth token. Required if `gh_create_vcs_repo` is true. | `string` | `null` | no |
| <a name="input_gh_repo_allow_merge_commit"></a> [gh\_repo\_allow\_merge\_commit](#input\_gh\_repo\_allow\_merge\_commit) | Allow merge commits | `bool` | `true` | no |
| <a name="input_gh_repo_allow_rebase_merge"></a> [gh\_repo\_allow\_rebase\_merge](#input\_gh\_repo\_allow\_rebase\_merge) | Allow rebase merges | `bool` | `true` | no |
| <a name="input_gh_repo_allow_squash_merge"></a> [gh\_repo\_allow\_squash\_merge](#input\_gh\_repo\_allow\_squash\_merge) | Allow squash merges | `bool` | `true` | no |
| <a name="input_gh_repo_delete_branch_on_merge"></a> [gh\_repo\_delete\_branch\_on\_merge](#input\_gh\_repo\_delete\_branch\_on\_merge) | Delete branch on merge | `bool` | `true` | no |
| <a name="input_gh_repo_description"></a> [gh\_repo\_description](#input\_gh\_repo\_description) | The description of the repository | `string` | `null` | no |
| <a name="input_gh_repo_has_issues"></a> [gh\_repo\_has\_issues](#input\_gh\_repo\_has\_issues) | Enable issues | `bool` | `true` | no |
| <a name="input_gh_repo_has_projects"></a> [gh\_repo\_has\_projects](#input\_gh\_repo\_has\_projects) | Enable projects | `bool` | `false` | no |
| <a name="input_gh_repo_has_wiki"></a> [gh\_repo\_has\_wiki](#input\_gh\_repo\_has\_wiki) | Enable wiki | `bool` | `false` | no |
| <a name="input_gh_repo_name"></a> [gh\_repo\_name](#input\_gh\_repo\_name) | The name of the repository to create. | `string` | `null` | no |
| <a name="input_gh_repo_template_include_all_branches"></a> [gh\_repo\_template\_include\_all\_branches](#input\_gh\_repo\_template\_include\_all\_branches) | Include all branches in the template | `bool` | `false` | no |
| <a name="input_gh_repo_template_owner"></a> [gh\_repo\_template\_owner](#input\_gh\_repo\_template\_owner) | The owner of the repository to use as a template. | `string` | `null` | no |
| <a name="input_gh_repo_template_repo"></a> [gh\_repo\_template\_repo](#input\_gh\_repo\_template\_repo) | The name of the repository to use as a template. | `string` | `null` | no |
| <a name="input_gh_repo_topics"></a> [gh\_repo\_topics](#input\_gh\_repo\_topics) | Repository topics | `list(string)` | `[]` | no |
| <a name="input_gh_repo_visibility"></a> [gh\_repo\_visibility](#input\_gh\_repo\_visibility) | The visibility of the repository | `string` | `"private"` | no |
| <a name="input_gh_repo_vulnerability_alerts"></a> [gh\_repo\_vulnerability\_alerts](#input\_gh\_repo\_vulnerability\_alerts) | Enable vulnerability alerts | `bool` | `true` | no |
| <a name="input_gh_repo_web_commit_signoff_required"></a> [gh\_repo\_web\_commit\_signoff\_required](#input\_gh\_repo\_web\_commit\_signoff\_required) | Require web commit signoff | `bool` | `true` | no |
| <a name="input_project_team_access"></a> [project\_team\_access](#input\_project\_team\_access) | The permission set the team should have on the project. Valid values are `read`, `write`, `maintain`, or `admin`. | `string` | `"maintain"` | no |
| <a name="input_team_sso_team_id"></a> [team\_sso\_team\_id](#input\_team\_sso\_team\_id) | (Optional) The SSO team ID to associate with the team. To pair with SSO must either provide the IDP ID for team or match the `team_name` to IDP name. | `string` | `null` | no |
| <a name="input_team_visibility"></a> [team\_visibility](#input\_team\_visibility) | The visibility of the team to create. Valid values are `secret` or `organization`. | `string` | `"secret"` | no |
| <a name="input_workspace_assessment_enabled"></a> [workspace\_assessment\_enabled](#input\_workspace\_assessment\_enabled) | Whether to enable health checks for the workspace. | `bool` | `true` | no |
| <a name="input_workspace_auto_apply"></a> [workspace\_auto\_apply](#input\_workspace\_auto\_apply) | Whether to automatically apply changes to the workspace. | `bool` | `true` | no |
| <a name="input_workspace_force_delete"></a> [workspace\_force\_delete](#input\_workspace\_force\_delete) | Whether to force delete the workspace. | `bool` | `false` | no |
| <a name="input_workspace_structured_run_output_enabled"></a> [workspace\_structured\_run\_output\_enabled](#input\_workspace\_structured\_run\_output\_enabled) | Whether to enable structured run output for the workspace. | `bool` | `false` | no |
| <a name="input_workspace_terraform_version"></a> [workspace\_terraform\_version](#input\_workspace\_terraform\_version) | The version of Terraform to use for the workspace. Default of `null` will use latest version at workspace creation point in time. | `string` | `null` | no |
| <a name="input_workspace_vcs_ingress_submodules"></a> [workspace\_vcs\_ingress\_submodules](#input\_workspace\_vcs\_ingress\_submodules) | Ingress submodules field for TFE Workspace VCS settings | `bool` | `false` | no |
| <a name="input_workspace_vcs_repo_branch"></a> [workspace\_vcs\_repo\_branch](#input\_workspace\_vcs\_repo\_branch) | The branch to use for WS VCS repo | `string` | `"main"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_repository_attributes"></a> [github\_repository\_attributes](#output\_github\_repository\_attributes) | Attributes of the GitHub repository |
| <a name="output_tfe_project_attributes"></a> [tfe\_project\_attributes](#output\_tfe\_project\_attributes) | Attributes of the TFE Project |
| <a name="output_tfe_team_attributes"></a> [tfe\_team\_attributes](#output\_tfe\_team\_attributes) | Attributes of the TFE Team |
| <a name="output_tfe_workspace_attributes"></a> [tfe\_workspace\_attributes](#output\_tfe\_workspace\_attributes) | Attributes of the TFE Workspace |
<!-- END_TF_DOCS -->