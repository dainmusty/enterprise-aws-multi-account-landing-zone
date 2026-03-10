resource "aws_instance" "github_runner" {
  provider      = aws.shared_services
  ami           = var.ami_id
  instance_type = "t3.medium"
  # pick first private subnet by index
  subnet_id     = aws_subnet.shared_private[0].id

  iam_instance_profile = aws_iam_instance_profile.runner_profile.name
}