locals {
  interface_services = [
    "ec2",
    "ssm",
    "ssmmessages",
    "ec2messages",
    "logs",
    "kms",
    "ecr.api",
    "ecr.dkr"
  ]
}

# Security group for interface endpoints
resource "aws_security_group" "prod_endpoints" {
  provider   = aws.prod
  name       = "prod-endpoints-sg"
  description = "Security group attached to prod VPC interface endpoints"
  vpc_id     = aws_vpc.prod.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.prod.cidr_block]
    description = "Allow HTTPS traffic from within VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "prod-endpoints-sg"
  }
}


resource "aws_vpc_endpoint" "interface" {
  for_each          = toset(local.interface_services)
  provider          = aws.prod
  vpc_id            = aws_vpc.prod.id
  service_name      = "com.amazonaws.us-east-1.${each.key}"
  vpc_endpoint_type = "Interface"

  subnet_ids         = aws_subnet.prod_private[*].id
  security_group_ids = [aws_security_group.prod_endpoints.id]
}