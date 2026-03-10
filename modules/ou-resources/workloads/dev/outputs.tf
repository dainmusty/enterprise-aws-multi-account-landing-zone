output "eks_oidc_provider_url" {
  value       = aws_eks_cluster.dev.identity[0].oidc[0].issuer
  description = "OIDC provider URL for the EKS cluster in dev account"
  
}
