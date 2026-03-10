resource "aws_iam_role" "cleanup_role" {
  provider = aws.sandbox

  name = "sandbox-cleanup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cleanup_role_attachment" {
  provider = aws.sandbox

  role       = aws_iam_role.cleanup_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}