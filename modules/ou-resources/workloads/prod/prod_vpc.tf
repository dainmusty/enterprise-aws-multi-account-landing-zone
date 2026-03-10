resource "aws_vpc" "prod" {
  provider   = aws.prod
  cidr_block = "10.10.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Availability zones for the prod VPC
data "aws_availability_zones" "available" {
  provider = aws.prod
  state    = "available"
}

# Private subnets for the prod VPC
resource "aws_subnet" "prod_private" {
  count             = 3
  provider          = aws.prod
  vpc_id            = aws_vpc.prod.id
  cidr_block        = cidrsubnet("10.40.0.0/16", 4, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
}


# Route tables for prod VPC
resource "aws_route_table" "prod_private" {
  provider = aws.prod
  vpc_id   = aws_vpc.prod.id

  tags = {
    Name = "prod-private-rt"
  }
}

resource "aws_route_table_association" "prod_private_assoc" {
  count          = length(aws_subnet.prod_private)
  provider       = aws.prod
  subnet_id      = aws_subnet.prod_private[count.index].id
  route_table_id = aws_route_table.prod_private.id
}

# leaving a placeholder public table for future use
resource "aws_route_table" "prod_public" {
  provider = aws.prod
  vpc_id   = aws_vpc.prod.id

  tags = {
    Name = "prod-public-rt"
  }
}

# Cross-Account Routing
# Route in prod VPC to send traffic to core VPC via TGW
resource "aws_route" "prod_to_core" {
  provider               = aws.prod
  route_table_id         = aws_route_table.prod_private.id
  destination_cidr_block = "10.0.0.0/16" # Core VPC
  transit_gateway_id     = var.tgw_id
}

