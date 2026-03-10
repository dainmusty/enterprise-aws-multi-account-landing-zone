# Prod VPC Flow logs
resource "aws_flow_log" "vpc_flow_logs" {
  provider = aws.prod

  iam_role_arn = aws_iam_role.vpc_flow_logs_role.arn # needs to be created in the security account and passed in as a variable and you need an IAM role with permissions to publish to the central log bucket
  log_destination = var.central_log_bucket_arn
  traffic_type = "ALL"
  vpc_id = aws_vpc.prod.id
}

