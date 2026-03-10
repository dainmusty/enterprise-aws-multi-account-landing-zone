variable "env" {
  type = string
  description = "environment name"
}

variable "region" {
  type = string
  description = "aws region"
}

variable "central_log_bucket_arn" {
  type = string
  description = "ARN of the central log bucket in the security account"
}

