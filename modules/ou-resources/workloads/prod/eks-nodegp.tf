resource "aws_eks_node_group" "prod_general" {
  provider      = aws.prod
  cluster_name  = aws_eks_cluster.prod.name
  node_role_arn = aws_iam_role.node.arn
  subnet_ids    = aws_subnet.prod_private[*].id

  scaling_config {
    desired_size = 3
    max_size     = 6
    min_size     = 3
  }

  instance_types = ["m6i.large"]
}

resource "aws_iam_role" "node" {
  provider = aws.prod
  name     = "prod-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  provider = aws.prod
  role     = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  provider = aws.prod
  role     = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  provider = aws.prod
  role     = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

