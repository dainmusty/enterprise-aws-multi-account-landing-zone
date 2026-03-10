# Transit Gateway Attachment for shared VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "shared" {
  provider           = aws.shared_services
  # uses all instances from counted subnets
  subnet_ids         = aws_subnet.shared_private[*].id
  transit_gateway_id = var.tgw_id
  vpc_id             = aws_vpc.shared.id

  tags = {
    Name = "shared-tgw-attachment"
  }
}
