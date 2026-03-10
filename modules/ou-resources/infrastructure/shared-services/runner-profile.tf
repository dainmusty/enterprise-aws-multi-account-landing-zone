resource "aws_iam_role" "runner_role" {
  provider = aws.shared_services

  name = "shared-services-github-runner-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "runner_managed" {
  provider = aws.shared_services

  role       = aws_iam_role.runner_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "runner_profile" {
  provider = aws.shared_services

  name = "shared-services-github-runner-profile"
  role = aws_iam_role.runner_role.name
}