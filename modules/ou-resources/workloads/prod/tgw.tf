resource "aws_ec2_transit_gateway_vpc_attachment" "prod" {
  provider           = aws.prod
  vpc_id             = aws_vpc.prod.id
  subnet_ids         = aws_subnet.prod_private[*].id
  transit_gateway_id = var.tgw_id
}