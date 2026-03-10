variable "tgw_id" {
  type = string
  description = "transit gateway id"
}

variable "central_log_bucket_arn" {
  type = string
  description = "ARN of the central log bucket in the security account"
}

variable "prod_account_id" {
  type = string
  description = "prod account id"
}

variable "oidc_provider" {
  type = object({
    eks = object({
      url = string
    })
  })
  description = "OIDC provider details for EKS cluster"
}