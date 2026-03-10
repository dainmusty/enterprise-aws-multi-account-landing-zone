# Enable IRSA Enable OIDC
resource "aws_iam_openid_connect_provider" "eks" {
  url = aws_eks_cluster.dev.identity[0].oidc[0].issuer

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = ["09e99a48a9960b14926bb7f3b02e22da0afd40e6"]
}

# This configuration enables several features including the ALB controller, 
# External DNS, the EBS CSI driver, External Secrets, and provides secure pod identity
# (no IAM credentials in pods), resulting in an enterprise-grade Kubernetes cluster.