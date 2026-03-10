resource "aws_vpc" "core" {
  provider = aws.network

  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "core-network-vpc"
  }
}


# VPC Flow logs
# resource "aws_flow_log" "vpc_flow_logs" {
#   provider = aws.network

#   iam_role_arn = var.flow_logs_role_arn # needs to be created in the security account and passed in as a variable and you need an IAM role with permissions to publish to the central log bucket
#   log_destination = var.central_log_bucket_arn
#   traffic_type = "ALL"
#   vpc_id = aws_vpc.core.id
# }

# Availability Zones
data "aws_availability_zones" "available" {
  provider = aws.network
  state    = "available"
}

# Private Subnets for Route53 Resolver
resource "aws_subnet" "core_private_a" {
  provider            = aws.network
  vpc_id              = aws_vpc.core.id
  cidr_block          = "10.0.1.0/24"
  availability_zone   = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "core-private-subnet-a"
  }
}

resource "aws_subnet" "core_private_b" {
  provider            = aws.network
  vpc_id              = aws_vpc.core.id
  cidr_block          = "10.0.2.0/24"
  availability_zone   = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "core-private-subnet-b"
  }
}


# Route Tables for private subnets
resource "aws_route_table" "core_private" {
  provider = aws.network
  vpc_id   = aws_vpc.core.id

  tags = {
    Name = "core-private-rt"
  }
}

# Route Tables for public subnets
resource "aws_route_table" "core_public" {
  provider = aws.network
  vpc_id   = aws_vpc.core.id

  tags = {
    Name = "core-public-rt"
  }
}

resource "aws_route_table_association" "core_private_a_assoc" {
  provider       = aws.network
  subnet_id      = aws_subnet.core_private_a.id
  route_table_id = aws_route_table.core_private.id
}

resource "aws_route_table_association" "core_private_b_assoc" {
  provider       = aws.network
  subnet_id      = aws_subnet.core_private_b.id
  route_table_id = aws_route_table.core_private.id
}


# Route in core VPC to send traffic to dev and shared VPC via TGW
resource "aws_route" "core_to_dev" {
  provider = aws.network
  route_table_id         = aws_route_table.core_private.id
  destination_cidr_block = "10.10.0.0/16" # Dev VPC
  transit_gateway_id     = aws_ec2_transit_gateway.enterprise.id
}

resource "aws_route" "core_to_shared" {
  provider = aws.network
  route_table_id         = aws_route_table.core_private.id
  destination_cidr_block = "10.20.0.0/16" # Shared VPC
  transit_gateway_id     = aws_ec2_transit_gateway.enterprise.id
}








