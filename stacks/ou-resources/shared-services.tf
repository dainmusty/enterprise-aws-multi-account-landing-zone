module "shared_services" {
  source = "../../modules/ou-resources/infrastructure/shared-services"
  
  providers = {
    aws.shared_services = aws.shared_services
  }
tgw_id = data.terraform_remote_state.ou_resources.outputs.transit_gateway_enterprise_id
depends_on = [ module.network ]
ami_id = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI ID for us-east-1, replace with appropriate AMI for your region
dev_acc_id = data.terraform_remote_state.ou_accounts.outputs.account_ids["dev"]
prod_acc_id = data.terraform_remote_state.ou_accounts.outputs.account_ids["prod"]


}

