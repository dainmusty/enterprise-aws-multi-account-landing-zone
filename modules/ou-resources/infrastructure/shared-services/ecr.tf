# Centralized ECR
resource "aws_ecr_repository" "shared" {
  provider = aws.shared_services
  name     = "enterprise-apps"
}

# Allow cross-account read access to ECR repository for dev and prod accounts
resource "aws_ecr_repository_policy" "cross_account" {
  repository = aws_ecr_repository.shared.name

  policy = jsonencode({
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::${var.dev_acc_id}:root",
            "arn:aws:iam::${var.prod_acc_id}:root"
          ]
        }
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
      }
    ]
  })
}