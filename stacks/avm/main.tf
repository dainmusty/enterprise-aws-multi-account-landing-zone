module "account_vending_machine" {    # This module creates AWS accounts based on YAML files in the accounts directory
  source = "../../modules/account-vending-machine"  # Developers can add new accounts by creating a YAML file in the accounts directory with the required fields (name, email, ou, owner, environment)

}


