resource "aws_eks_cluster" "dev" {
  provider = aws.dev
  name     = "dev-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids              = aws_subnet.dev_private[*].id
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.eks.arn
    }
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator"
  ]
}

# EKS Node Group
resource "aws_eks_node_group" "dev" {
  provider       = aws.dev
  cluster_name   = aws_eks_cluster.dev.name
  node_role_arn  = aws_iam_role.node.arn
  subnet_ids     = aws_subnet.dev_private[*].id

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }

  instance_types = ["t3.medium"]
}


