# Endpoint for Route53 Resolver in core VPC
resource "aws_route53_resolver_endpoint" "inbound" {
  name      = "central-inbound-resolver"
  direction = "INBOUND"

  security_group_ids = [aws_security_group.resolver_sg.id]

  ip_address {
    subnet_id = aws_subnet.core_private_a.id
  }

  ip_address {
    subnet_id = aws_subnet.core_private_b.id
  }
}

resource "aws_route53_resolver_endpoint" "outbound" {
  name      = "central-outbound-resolver"
  direction = "OUTBOUND"

  security_group_ids = [aws_security_group.resolver_sg.id]

  ip_address {
    subnet_id = aws_subnet.core_private_a.id
  }

  ip_address {
    subnet_id = aws_subnet.core_private_b.id
  }
}

# Security Group for Route53 Resolver Endpoint
resource "aws_security_group" "resolver_sg" {
  provider    = aws.network
  name        = "resolver-endpoint-sg"
  description = "Security group for Route53 Resolver endpoint"
  vpc_id      = aws_vpc.core.id

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow DNS queries from VPC"
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow DNS queries from VPC (TCP)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "resolver-endpoint-sg"
  }
}
