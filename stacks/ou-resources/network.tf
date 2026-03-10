module "network" {
  source = "../../modules/ou-resources/infrastructure/network"
  
  providers = {
    aws.network = aws.network
    }
#   flow_logs_role_arn        = data.terraform_remote_state.ou_accounts.outputs.flow_logs_role_arn
  central_log_bucket_arn    = data.terraform_remote_state.ou_resources.outputs.central_log_bucket_arn
  dev_account_id            = data.terraform_remote_state.ou_accounts.outputs.dev_account_id
  dev_vpc_id = data.terraform_remote_state.workloads.outputs.dev_vpc_id
}
