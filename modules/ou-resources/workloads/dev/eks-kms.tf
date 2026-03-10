# KMS key for encrypting EKS secrets
resource "aws_kms_key" "eks" {
  provider             = aws.dev
  description          = "KMS key for EKS cluster secrets in dev"
  deletion_window_in_days = 30

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "Allow access for Key Administrators"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action    = "kms:*"
        Resource  = "*"
      },
      {
        Sid       = "Allow use of the key"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}

data "aws_caller_identity" "current" {
  provider = aws.dev
}