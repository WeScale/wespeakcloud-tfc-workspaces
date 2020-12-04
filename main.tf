terraform {
  required_providers {
    tfe = "~> 0.15.0"
  }
}

locals {
  dummy_project_name = "wespeakcloud-dummy-tf"
}

module "dummy" {
  source  = "app.terraform.io/wescalefr/basic_workspace/tfe"
  version = "0.1.0"

  name = local.dummy_project_name
  organization_id = var.organization_id
  oauth_token_id = var.github_oauth_token_id
  vcs_repo_identifier = "WeScale/${local.dummy_project_name}"
}
