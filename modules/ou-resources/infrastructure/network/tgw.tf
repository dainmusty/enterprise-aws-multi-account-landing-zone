resource "aws_ec2_transit_gateway" "enterprise" {
  provider = aws.network

  description = "Enterprise Transit Gateway"

  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = {
    Name = "enterprise-tgw"
  }
}

# Transit Gateway Attachment for core VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "core" {
  provider           = aws.network
  subnet_ids         = [aws_subnet.core_private_a.id, aws_subnet.core_private_b.id]
  transit_gateway_id = aws_ec2_transit_gateway.enterprise.id
  vpc_id             = aws_vpc.core.id

  tags = {
    Name = "core-tgw-attachment"
  }
}

