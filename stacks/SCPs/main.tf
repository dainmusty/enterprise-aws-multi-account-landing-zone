# This file defines the main configuration for the accounts stack. 
# It retrieves necessary information from the organization stack and then uses that information to create organizational units and accounts.

data "terraform_remote_state" "landing_zone" {
  for_each = local.remote_states

  backend = "s3"

  config = {
    bucket = "your-bucket-name"
    key    = each.value
    region = "us-east-1"
  }
}

locals {
  remote_states = {
    org          = "landing-zone/org/terraform.tfstate"
    ou_resources = "landing-zone/ou-resources/terraform.tfstate"
    ou_accounts  = "landing-zone/ou-accounts/terraform.tfstate"
  }

  security_ou_id  = data.terraform_remote_state.landing_zone["org"].outputs.security_ou_id
  workloads_ou_id = data.terraform_remote_state.landing_zone["org"].outputs.workloads_ou_id
  sandbox_ou_id   = data.terraform_remote_state.landing_zone["org"].outputs.sandbox_ou_id
  infra_ou_id     = data.terraform_remote_state.landing_zone["org"].outputs.infrastructure_ou_id

  ou_ids = {
    security  = local.security_ou_id
    workloads = local.workloads_ou_id
    sandbox   = local.sandbox_ou_id
    infra     = local.infra_ou_id
  }

  policies = fileset("${path.module}/policies", "*.json")

  policy_contents = {
    for p in local.policies :
    p => file("${path.module}/policies/${p}")
  }

  policy_to_ou = yamldecode(
    file("${path.module}/config/policy-mapping.yaml")
  )
}


module "SCPs" {
  source = "../../modules/SCPs"

  policy_contents = local.policy_contents
  policy_to_ou    = local.policy_to_ou
  ou_ids          = local.ou_ids
  
}