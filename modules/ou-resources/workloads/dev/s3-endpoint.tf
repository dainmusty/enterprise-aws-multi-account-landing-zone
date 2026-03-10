
# Deploy VPC Endpoints (Dev Account)
# S3 Endpoint Configuration, Critical for security baseline.
resource "aws_vpc_endpoint" "s3" {
  provider          = aws.dev
  vpc_id            = aws_vpc.dev.id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_route_table.dev_private.id]
}