# Hosted Zone for internal DNS
resource "aws_route53_zone" "internal" {
  name = "internal.company.local"

  vpc {
    vpc_id = aws_vpc.core.id
  }
}

# Centralized DNS for Dev VPC
# Associate the internal hosted zone with the dev VPC
resource "aws_route53_zone_association" "dev_assoc" {
  zone_id = aws_route53_zone.internal.zone_id
  vpc_id  = var.dev_vpc_id
}