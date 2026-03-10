# Resource Access Manager (RAM) to share Route53 zone with other accounts
resource "aws_ram_resource_share" "dns_share" {
  name = "central-dns-share"
}

resource "aws_ram_principal_association" "dev" {
  principal          = var.dev_account_id
  resource_share_arn = aws_ram_resource_share.dns_share.arn
}

resource "aws_ram_resource_association" "zone" {
  resource_arn       = aws_route53_zone.internal.arn
  resource_share_arn = aws_ram_resource_share.dns_share.arn
}