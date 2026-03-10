resource "aws_vpc" "shared" {
  provider   = aws.shared_services
  cidr_block = "10.20.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Availability zones for the shared VPC
data "aws_availability_zones" "available" {
  provider = aws.shared_services
  state    = "available"
}

# Private subnets for the shared VPC
resource "aws_subnet" "shared_private" {
  count                   = 2   # You can make a variable for this if you want more or fewer subnets
  provider                = aws.shared_services
  vpc_id                  = aws_vpc.shared.id
  cidr_block              = cidrsubnet(aws_vpc.shared.cidr_block, 8, count.index + 1) # 10.20.1.0/24, 10.20.2.0/24
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "shared-private-${count.index + 1}"
  }
}

# Route tables for shared VPC
resource "aws_route_table" "shared_private" {
  provider = aws.shared_services
  vpc_id   = aws_vpc.shared.id

  tags = {
    Name = "shared-private-rt"
  }
}

resource "aws_route_table_association" "shared_private_assoc" {
  count          = length(aws_subnet.shared_private)
  provider       = aws.shared_services
  subnet_id      = aws_subnet.shared_private[count.index].id
  route_table_id = aws_route_table.shared_private.id
}

# leaving a placeholder public table for future use
resource "aws_route_table" "shared_public" {
  provider = aws.shared_services
  vpc_id   = aws_vpc.shared.id

  tags = {
    Name = "shared-public-rt"
  }
}

# Cross-Account Routing
# Route in shared VPC to send traffic to core VPC via TGW
resource "aws_route" "shared_to_core" {
  provider               = aws.shared_services
  route_table_id         = aws_route_table.shared_private.id
  destination_cidr_block = "10.0.0.0/16" # Core VPC

  transit_gateway_id     = var.tgw_id
}

