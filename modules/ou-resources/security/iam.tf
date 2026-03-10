resource "aws_iam_role" "vpc_flow_logs_role" {
  name = "vpc-flow-logs-role"   
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Effect = "Allow"
            Principal = {
            Service = "vpc-flow-logs.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        }
        ]
    })
}

resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name = "vpc-flow-logs-policy"
  role = aws_iam_role.vpc_flow_logs_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetBucketAcl"
        ]
        Resource = [
          "${aws_s3_bucket.org_cloudtrail.arn}/*",
          aws_s3_bucket.org_cloudtrail.arn
        ]
      }
    ]
  })
}