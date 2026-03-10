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
  alias  = "dev"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::${local.account_ids["dev"]}:role/OrganizationAccountAccessRole"
  }
}

# Prod Account Provider
provider "aws" {
  alias  = "prod"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::${local.account_ids["prod"]}:role/OrganizationAccountAccessRole"
  }
}


provider "aws" {
  alias  = "prod_dr"
  region = "us-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${local.account_ids["prod"]}:role/OrganizationAccountAccessRole"
  }
}

provider "helm" {
  alias = "prod"

}

provider "kubernetes" {
  alias = "prod"
}


locals {  
    account_ids = data.terraform_remote_state.ou_accounts.outputs.account_ids["prod"]
  }

