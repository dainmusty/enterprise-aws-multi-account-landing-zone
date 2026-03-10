resource "aws_vpc" "dev" {
  provider   = aws.dev
  cidr_block = "10.10.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Availability zones for the dev VPC
data "aws_availability_zones" "available" {
  provider = aws.dev
  state    = "available"
}

# Private subnets for the dev VPC
resource "aws_subnet" "dev_private" {
  count                   = 2   # You can make a variable for this if you want more or fewer subnets
  provider                = aws.dev
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = cidrsubnet(aws_vpc.dev.cidr_block, 8, count.index + 1) # 10.20.1.0/24, 10.20.2.0/24
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "dev-private-${count.index + 1}"
  }
}

# Route tables for dev VPC
resource "aws_route_table" "dev_private" {
  provider = aws.dev
  vpc_id   = aws_vpc.dev.id

  tags = {
    Name = "dev-private-rt"
  }
}

resource "aws_route_table_association" "dev_private_assoc" {
  count          = length(aws_subnet.dev_private)
  provider       = aws.dev
  subnet_id      = aws_subnet.dev_private[count.index].id
  route_table_id = aws_route_table.dev_private.id
}

# leaving a placeholder public table for future use
resource "aws_route_table" "dev_public" {
  provider = aws.dev
  vpc_id   = aws_vpc.dev.id

  tags = {
    Name = "dev-public-rt"
  }
}

# Cross-Account Routing
# Route in dev VPC to send traffic to core VPC via TGW
resource "aws_route" "dev_to_core" {
  provider               = aws.dev
  route_table_id         = aws_route_table.dev_private.id
  destination_cidr_block = "10.0.0.0/16" # Core VPC
  transit_gateway_id     = var.tgw_id
}

