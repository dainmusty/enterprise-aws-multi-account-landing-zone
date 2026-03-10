module "prod" {
  source = "../../modules/ou-resources/workloads/prod"

  providers = {
    aws.prod     = aws.prod
    aws.prod_dr  = aws.prod_dr
    helm.prod    = helm.prod
    kubernetes.prod = kubernetes.prod
  }

  tgw_id = data.terraform_remote_state.ou_resources.outputs.tgw_id

  central_log_bucket_arn = data.terraform_remote_state.ou_resources.outputs.log_archive_bucket_name

  prod_account_id = data.terraform_remote_state.ou_resources.outputs.account_ids["prod"]

  oidc_provider = {
    eks = {
      url = data.terraform_remote_state.ou_resources.outputs.eks_oidc_provider_url
    }
  }
}