data "aws_caller_identity" "current" {
  provider = aws.log_archive
}


resource "aws_s3_bucket" "org_cloudtrail" {
  provider = aws.log_archive

  bucket = "lz-${var.env}-${var.region}-cloudtrail-${data.aws_caller_identity.current.account_id}"

  force_destroy = false
}

resource "aws_s3_bucket_versioning" "versioning" {
  provider = aws.log_archive

  bucket = aws_s3_bucket.org_cloudtrail.id

  versioning_configuration {
    status = "Enabled"
  }
}


# Bucket policy to allow CloudTrail to write logs to the bucket
resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  provider = aws.log_archive

  bucket = aws_s3_bucket.org_cloudtrail.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowOrganizationCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.org_cloudtrail.arn}/AWSLogs/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = [
          "kms:GenerateDataKey*",
          "kms:Decrypt"
        ]
        Resource = "*"
      }
    ]
  })
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "block_public" {
  provider = aws.log_archive
  bucket   = aws_s3_bucket.org_cloudtrail.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# KMS key for encrypting CloudTrail logs
resource "aws_kms_key" "cloudtrail_kms" {
  provider = aws.log_archive

  description             = "KMS key for Organization CloudTrail logs"
  enable_key_rotation     = true
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "cloudtrail_alias" {
  provider      = aws.log_archive
  name          = "alias/lz-cloudtrail"
  target_key_id = aws_kms_key.cloudtrail_kms.key_id
}

# Configure server-side encryption for the S3 bucket using the KMS key
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  provider = aws.log_archive
  bucket   = aws_s3_bucket.org_cloudtrail.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.cloudtrail_kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# # Lifecycle policy to transition logs to cheaper storage and eventually expire them
# resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
#   provider = aws.log_archive
#   bucket   = aws_s3_bucket.org_cloudtrail.id

#   rule {
#     id     = "cloudtrail-archive"
#     status = "Enabled"

#     transition {
#       days          = 90
#       storage_class = "STANDARD_IA"
#     }

#     transition {
#       days          = 180
#       storage_class = "GLACIER"
#     }

#     expiration {
#       days = 3650 # 10 years (adjust per compliance)
#     }
#   }
# }

