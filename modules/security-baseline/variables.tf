variable "audit_acc_id" {
  type = string
  description = "audit account id"
}

variable "log_archive_bucket_name" {
  type = string
  description = "log archive bucket name"
}

variable "cloudtrail_kms_key_arn" {
  type = string
  description = "KMS key ID for encrypting CloudTrail logs"
}

variable "cloudtrail_bucket_policy_arn" {
  type = string
  description = "ARN of the bucket policy for the CloudTrail S3 bucket"
}