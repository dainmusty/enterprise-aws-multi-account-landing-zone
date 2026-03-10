resource "aws_cloudtrail" "organization_trail" {
  
  name                          = "lz-org-trail"
  s3_bucket_name                = var.log_archive_bucket_name
  kms_key_id                    = var.cloudtrail_kms_key_arn
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  is_organization_trail         = true
  include_global_service_events = true

  depends_on = [
    var.cloudtrail_bucket_policy_arn
  ]
  
}

#
resource "aws_organizations_delegated_administrator" "config" {
  account_id        = var.audit_acc_id
  service_principal = "config.amazonaws.com"
}

# GuardDuty Admin Account
resource "aws_guardduty_organization_admin_account" "audit_admin" {
  admin_account_id = var.audit_acc_id
}

# SecurityHub Admin Account
resource "aws_securityhub_organization_admin_account" "audit_admin" {
  admin_account_id = var.audit_acc_id
}
