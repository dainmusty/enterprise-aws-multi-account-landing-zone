# This file defines the main configuration for the accounts stack. 
# It retrieves necessary information from the organization stack and then uses that information to create organizational units and accounts.
data "terraform_remote_state" "ou_accounts" {
  backend = "s3"

  config = {
    bucket = "your-bucket-name" #put the org-terraform-state bucket name here"
    key    = "landing-zone/ou-accounts/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "ou_resources" {
  backend = "s3"

  config = {
    bucket = "your-bucket-name" #put the org-terraform-state bucket name here"
    key    = "landing-zone/ou-resources/terraform.tfstate"
    region = "us-east-1"
  }
}

