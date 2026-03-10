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

# Log Archive Account Provider
provider "aws" {
  alias  = "log_archive"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::${local.account_ids["log_archive"]}:role/OrganizationAccountAccessRole"
  }
}

# Audit Account Provider
provider "aws" {
  alias  = "audit"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::${local.account_ids["audit"]}:role/OrganizationAccountAccessRole"
  }
}

# Network Account Provider
provider "aws" {
  alias  = "network"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::${local.account_ids["network"]}:role/OrganizationAccountAccessRole"
  }
}

# Shared Services Account Provider
provider "aws" {
  alias  = "shared_services"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::${local.account_ids["shared_services"]}:role/OrganizationAccountAccessRole"
  }
}


  

