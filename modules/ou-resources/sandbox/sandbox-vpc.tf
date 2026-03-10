# Keep it small and cheap in the sandbox! 
resource "aws_vpc" "sandbox_vpc" {
  provider = aws.sandbox

  cidr_block = "10.50.0.0/16"

  tags = {
    Name = "sandbox-vpc"
  }
}


resource "aws_subnet" "sandbox_public" {
  provider = aws.sandbox

  vpc_id            = aws_vpc.sandbox_vpc.id
  cidr_block        = "10.50.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "sandbox_private" {
  provider = aws.sandbox

  vpc_id            = aws_vpc.sandbox_vpc.id
  cidr_block        = "10.50.2.0/24"
  availability_zone = "us-east-1a"
}


# Availability zones for the dev VPC
data "aws_availability_zones" "available" {
  provider = aws.sandbox
  state    = "available"
}

# Route tables for sandbox VPC
resource "aws_route_table" "sandbox_private" {
  provider = aws.sandbox
  vpc_id   = aws_vpc.sandbox_vpc.id

  tags = {
    Name = "sandbox-private-rt"
  }
}

resource "aws_route_table_association" "sandbox_private_assoc" {
  provider       = aws.sandbox
  subnet_id      = aws_subnet.sandbox_private.id
  route_table_id = aws_route_table.sandbox_private.id
}

# leaving a placeholder public table for future use
resource "aws_route_table" "sandbox_public" {
  provider = aws.sandbox
  vpc_id   = aws_vpc.sandbox_vpc.id

  tags = {
    Name = "sandbox-public-rt"
  }
}

# Cross-Account Routing
# Route in sandbox VPC to send traffic to core VPC via TGW
resource "aws_route" "sandbox_to_core" {
  provider               = aws.sandbox
  route_table_id         = aws_route_table.sandbox_private.id
  destination_cidr_block = "10.0.0.0/16" # Core VPC
  transit_gateway_id     = var.tgw_id
}

