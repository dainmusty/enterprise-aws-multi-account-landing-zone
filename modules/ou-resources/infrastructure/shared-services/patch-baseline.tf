# AWS Systems Manager (Patch + Fleet Control)
# share baseline to other accounts via RAM. This gives centralized patch governance, automated patch windows. no SSH required
resource "aws_ssm_patch_baseline" "linux" {
  provider         = aws.shared_services
  name             = "enterprise-linux-baseline"
  operating_system = "AMAZON_LINUX_2"
}

