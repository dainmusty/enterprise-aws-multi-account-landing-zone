locals {
  tstate_bucket = "your-bucket-name"
  tstate_region = "us-east-1"
}

data "terraform_remote_state" "org" {
  backend = "s3"

  config = {
    bucket = local.tstate_bucket
    key    = "landing-zone/org/terraform.tfstate"
    region = local.tstate_region
  }
}

data "terraform_remote_state" "ou_accounts" {
  backend = "s3"

  config = {
    bucket = local.tstate_bucket
    key    = "landing-zone/ou-accounts/terraform.tfstate"
    region = local.tstate_region
  }
}


module "iam_access" {

  source = "../../modules/identity-center"

  accounts = data.terraform_remote_state.ou_accounts.outputs.accounts_ids

  depends_on = [
    module.account_vending_machine
  ]
}