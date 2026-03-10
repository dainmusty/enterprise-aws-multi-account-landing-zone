resource "aws_s3_bucket" "velero_backup" {
  provider = aws.prod

  bucket = "velero-backups-prod"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "velero" {
  provider = aws.prod

  bucket = aws_s3_bucket.velero_backup.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}