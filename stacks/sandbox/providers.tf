terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# OU Resources Providers
provider "aws" {
  region = "us-east-1"
  #profile = "default"
}

# Dev Account Provider
provider "aws" {
  alias  = "sandbox"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::${local.account_ids["sandbox"]}:role/OrganizationAccountAccessRole"
  }
}


locals {  
    account_ids = data.terraform_remote_state.ou_accounts.outputs.account_ids["prod"]
  }

