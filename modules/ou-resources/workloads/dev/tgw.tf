# Transit Gateway Attachment for dev VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "dev" {
  provider           = aws.dev
  subnet_ids         = aws_subnet.dev_private[*].id
  transit_gateway_id = var.tgw_id
  vpc_id             = aws_vpc.dev.id
}
