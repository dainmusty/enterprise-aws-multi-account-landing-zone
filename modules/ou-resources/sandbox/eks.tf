module "sandbox_eks" {
  source  = "terraform-aws-modules/eks/aws"

  providers = {
    aws = aws.sandbox
  }

  # cluster_name    = "sandbox-eks"
  # cluster_version = "1.29"

  vpc_id     = aws_vpc.sandbox_vpc.id
  subnet_ids = [aws_subnet.sandbox_public.id]

  eks_managed_node_groups = {
    sandbox = {
      instance_types = ["t3.small"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }
  }
}