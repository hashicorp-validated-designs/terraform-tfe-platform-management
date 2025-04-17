variable "organization" {
  description = "The name of the organization to create the project in."
  type        = string
}

variable "gh_app_id" {
  description = "The GitHub App ID to use for the repository."
  type        = string
}

variable "force_delete" {
  description = "Whether to force delete the workspace."
  type        = bool
  default     = false
}