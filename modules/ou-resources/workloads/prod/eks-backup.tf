# Velero for Kubernetes (EKS Backup) AWS Backup does NOT back up:Kubernetes objects, Namespaces, CRDs,Secrets (properly)
# Create a bucket for velero and enable versioning (best practice for backup buckets)
resource "aws_s3_bucket" "velero" {
  provider = aws.prod
  bucket   = "prod-velero-backups"
}

resource "aws_s3_bucket_versioning" "velero" {
  provider = aws.prod
  bucket   = aws_s3_bucket.velero.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Create IAM Role for Velero (IRSA)
resource "aws_iam_role" "velero_role" {
  provider = aws.prod
  name     = "prod-velero-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(var.oidc_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:velero:velero"
          }
        }
      }
    ]
  })
}

# Velero needs permissions for:S3,EBS snapshots,Attach minimal policy.
resource "aws_iam_role_policy" "velero_policy" {
  provider = aws.prod
  name     = "prod-velero-policy"
  role     = aws_iam_role.velero_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:GetBucketVersioning",
          "s3:PutBucketVersioning"
        ]
        Resource = [
          aws_s3_bucket.velero.arn,
          "${aws_s3_bucket.velero.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:DescribeSnapshots",
          "ec2:DescribeVolumes"
        ]
        Resource = "*"
      }
    ]
  })
}
