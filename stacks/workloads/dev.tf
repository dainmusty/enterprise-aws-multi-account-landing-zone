module "dev" {
  source = "../../modules/ou-resources/workloads/dev"
  
  providers = {
    aws.dev = aws.dev
    
  }
tgw_id = data.terraform_remote_state.ou_resources.outputs.transit_gateway_enterprise_id

}
