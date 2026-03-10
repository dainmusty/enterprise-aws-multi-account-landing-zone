resource "aws_eks_cluster" "prod" {
  provider = aws.prod
  name     = "prod-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids              = aws_subnet.prod_private[*].id
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.prod_eks.arn
    }
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
}

resource "aws_iam_role" "eks_cluster" {
  provider = aws.prod
  name     = "prod-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach necessary policies to the EKS cluster role
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  provider = aws.prod
  role     = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  provider = aws.prod
  role     = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_role_policy_attachment" "name" {
  provider = aws.prod
  role = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_kms_key" "prod_eks" {
  provider = aws.prod
  description = "KMS key for EKS secrets encryption in prod"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "Allow administration of the key"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.prod_account_id}:root"
        }
        Action = [
          "kms:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create IRSA for all add-ons on the cluster
