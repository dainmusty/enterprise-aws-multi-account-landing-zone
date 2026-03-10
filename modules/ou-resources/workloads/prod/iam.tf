resource "aws_iam_role" "vpc_flow_logs_role" {
  name = "vpc-flow-logs-role"   
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Effect = "Allow"
            Principal = {
            Service = "vpc-flow-logs.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        }
        ]
    })
}

resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name = "vpc-flow-logs-policy"
  role = aws_iam_role.vpc_flow_logs_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetBucketAcl"
        ]
        Resource = [
          "${var.central_log_bucket_arn}/*",
          var.central_log_bucket_arn
        ]
      }
    ]
  })
}

# Backup role for EKS cluster
resource "aws_iam_role" "backup_role" {
  name = "prod-eks-backup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider.eks.url
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


# IRSA for Velero backup service account
resource "aws_iam_role_policy_attachment" "backup_role_AmazonS3FullAccess" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "backup_role_AmazonDynamoDBFullAccess" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "backup_role_AmazonEBSFullAccess" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEBSFullAccess"
}

resource "aws_iam_role_policy_attachment" "backup_role_AmazonEC2FullAccess" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# Service account for Velero backup
resource "kubernetes_service_account_v1" "velero" {
  provider = kubernetes.prod

  metadata {
    name      = "velero"
    namespace = "velero"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.backup_role.arn
    }
  }
}
