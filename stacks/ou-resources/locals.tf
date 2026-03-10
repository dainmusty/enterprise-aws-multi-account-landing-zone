locals {
  env = "dev"
  region = "us-east-1" 
}



locals {
  account_ids = {
    network         = data.terraform_remote_state.ou_accounts.outputs.account_ids["network"]
    shared_services = data.terraform_remote_state.ou_accounts.outputs.account_ids["shared_services"]
    dev             = data.terraform_remote_state.ou_accounts.outputs.account_ids["dev"]
    prod            = data.terraform_remote_state.ou_accounts.outputs.account_ids["prod"]
    audit           = data.terraform_remote_state.ou_accounts.outputs.account_ids["audit"]
    log_archive     = data.terraform_remote_state.ou_accounts.outputs.account_ids["log_archive]"]
  }
}

  
