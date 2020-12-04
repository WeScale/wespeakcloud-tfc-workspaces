variable "github_token" {
  type = string
  description = "Token to connect TFC and github.com"
}

variable "organization_id" {
  type = string
  description = "Name of the organization hosting the workspaces"
}

variable "policies_repo_name" {
  type = string
  description = "Name of the policies repository in github"
}

variable "policies_path" {
  type = string
  description = "Path of the policies in the project"
  default = "."
}

variable "policies_repo_branch" {
  type = string
  description = "Branch of the policies repository"
  default = "main"
}

variable "github_basic_workspaces" {
  type = list(object({
    name = string
    identifier = string
  }))
  description = "List of basic Github workspaces"
}