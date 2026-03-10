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
resource "aws_security_group" "dev_endpoints" {
  provider   = aws.dev
  name       = "dev-endpoints-sg"
  description = "Security group attached to dev VPC interface endpoints"
  vpc_id     = aws_vpc.dev.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.dev.cidr_block]
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
    Name = "dev-endpoints-sg"
  }
}


resource "aws_vpc_endpoint" "interface" {
  for_each          = toset(local.interface_services)
  provider          = aws.dev
  vpc_id            = aws_vpc.dev.id
  service_name      = "com.amazonaws.us-east-1.${each.key}"
  vpc_endpoint_type = "Interface"

  subnet_ids         = aws_subnet.dev_private[*].id
  security_group_ids = [aws_security_group.dev_endpoints.id]
}