resource "aws_servicequotas_service_quota" "ec2_instances" {
  provider = aws.sandbox

  service_code = "ec2"
  quota_code   = "L-1216C47A"

  value = 5 # This means that the sandbox account will be limited to 5 EC2 instances. Adjust as necessary.
}