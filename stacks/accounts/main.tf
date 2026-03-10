# This file defines the main configuration for the accounts stack. 
# It retrieves necessary information from the organization stack and then uses that information to create organizational units and accounts.
data "terraform_remote_state" "org" {
  backend = "s3"

  config = {
    bucket = "your-bucket-name" #put the org-terraform-state bucket name here"
    key    = "landing-zone/org/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  org_outputs = data.terraform_remote_state.org.outputs

  ou_ids = {
    security       = local.org_outputs.security_ou_id
    infrastructure = local.org_outputs.infrastructure_ou_id
    workloads      = local.org_outputs.workloads_ou_id
    sandbox        = local.org_outputs.sandbox_ou_id
  }
}

locals {
  accounts = {
    audit = {
      name  = "Audit"
      email = "audit@example.com"
      ou_id = local.ou_ids.security
    }

    log_archive = {
      name  = "Log-Archive"
      email = "log-archive@example.com"
      ou_id = local.ou_ids.security
    }

    shared_services = {
      name  = "Shared-Services"
      email = "shared-services@example.com"
      ou_id = local.ou_ids.infrastructure
    }

    network = {
      name  = "Network"
      email = "network@example.com"
      ou_id = local.ou_ids.infrastructure
    }

    dev = {
      name  = "Dev"
      email = "dev@example.com"
      ou_id = local.ou_ids.workloads
    }

    prod = {
      name  = "Prod"
      email = "prod@example.com"
      ou_id = local.ou_ids.workloads
    }

    sandbox = {
      name  = "Sandbox"
      email = "sandbox@example.com"
      ou_id = local.ou_ids.sandbox
    }   
  }
}


module "ou_accounts" {
  source   = "../../modules/ou-accounts"
  
  accounts = local.accounts

}