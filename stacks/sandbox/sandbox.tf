module "sandbox" {
  source = "../../modules/ou-resources/sandbox"

  providers = {
    aws.sandbox = aws.sandbox
    
  }
tgw_id = data.terraform_remote_state.ou_resources.outputs.transit_gateway_enterprise_id


}
