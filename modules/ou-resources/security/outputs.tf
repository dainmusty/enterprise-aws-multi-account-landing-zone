output "log_archive_bucket_name" {
  value = aws_s3_bucket.org_cloudtrail.bucket
}

output "cloudtrail_kms_key_arn" {
  value = aws_kms_key.cloudtrail_kms.arn
}

output "cloudtrail_bucket_policy_arn" {
  # aws_s3_bucket_policy resources do not export an ARN; the ID is the bucket name
  # change to ID or rename output as needed by callers.  Using id for now.
  value = aws_s3_bucket_policy.cloudtrail_policy.id
}

# If callers actually require the bucket's arn they can use:
output "cloudtrail_bucket_policy_id" {
  value = aws_s3_bucket_policy.cloudtrail_policy.id
}
