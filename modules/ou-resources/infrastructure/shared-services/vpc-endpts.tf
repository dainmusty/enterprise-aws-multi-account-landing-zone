locals {
  interface_services = [
    "ec2",
    "ssm",
    "ssmmessages",
    "ec2messages",
    "logs",
    "kms",
    "s3",
    "ecr.api",
    "ecr.dkr"
  ]
}

# Security group for interface endpoints
resource "aws_security_group" "shared_endpoints" {
  provider   = aws.shared_services
  name       = "shared-endpoints-sg"
  description = "Security group attached to shared VPC interface endpoints"
  vpc_id     = aws_vpc.shared.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.shared.cidr_block]
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
    Name = "shared-endpoints-sg"
  }
}


resource "aws_vpc_endpoint" "interface" {
  for_each          = toset(local.interface_services)
  provider          = aws.shared_services
  vpc_id            = aws_vpc.shared.id
  service_name      = "com.amazonaws.us-east-1.${each.key}"
  vpc_endpoint_type = "Interface"

  subnet_ids         = aws_subnet.shared_private[*].id
  security_group_ids = [aws_security_group.shared_endpoints.id]
}