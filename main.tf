terraform {
  required_providers {
    tfe = "~> 0.23.0"
  }

  backend "remote" {
    organization = "wescalefr"

    workspaces {
      name = "wespeakcloud-tfc-workspaces"
    }
  }
}

locals {
  github_basic_workspaces = {
    for workspace in var.github_basic_workspaces:
    workspace.name => merge(workspace, {
      oauth_token_id = tfe_oauth_client.github_wescale.oauth_token_id
      identifier = "WeScale/${workspace.identifier}"
      organization_id = var.organization_id
    })
  }
}

resource "tfe_oauth_client" "github_wescale" {
  organization = var.organization_id
  api_url = "https://api.github.com"
  http_url = "https://github.com"
  oauth_token = var.github_token
  service_provider = "github"
}

resource "tfe_policy_set" "policies" {
  name = var.policies_repo_name
  organization = var.organization_id
  workspace_ids = [
    for key, workspace in module.basic_workspaces:
    workspace.id
  ]

  vcs_repo {
    identifier = "WeScale/${var.policies_repo_name}"
    branch = var.policies_repo_branch
    oauth_token_id = tfe_oauth_client.github_wescale.oauth_token_id
  }
}

module "basic_workspaces" {
  source  = "app.terraform.io/wescalefr/basic_workspace/tfe"
  version = "~> 0.1.0"
  
  for_each = local.github_basic_workspaces

  name = each.value.name
  organization_id = each.value.organization_id
  vcs_repo_identifier = each.value.identifier
  oauth_token_id = each.value.oauth_token_id
}

