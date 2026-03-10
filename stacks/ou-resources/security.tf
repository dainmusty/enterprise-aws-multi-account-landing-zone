module "ou_resources" {
  source = "../../modules/ou-resources/security"
  
    providers = {
    aws.log_archive = aws.log_archive
  }
    env          = local.env
    region       = local.region
    central_log_bucket_arn = data.terraform_remote_state.ou_resources.outputs.log_archive_bucket_name
}
