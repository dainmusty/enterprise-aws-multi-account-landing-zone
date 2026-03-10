output "organisation_id" {
  description = "The ID of the AWS Organization"
  value       = aws_organizations_organization.org.id
}

output "security_ou_id" {
  description = "The ID of the Security organizational unit"
  value       = aws_organizations_organizational_unit.security.id
}

output "infrastructure_ou_id" {
  description = "The ID of the Infrastructure organizational unit"
  value       = aws_organizations_organizational_unit.infrastructure.id
}

output "workloads_ou_id" {
  description = "The ID of the Workloads organizational unit"
  value       = aws_organizations_organizational_unit.workloads.id
}

output "sandbox_ou_id" {
  description = "The ID of the Sandbox organizational unit"
  value       = aws_organizations_organizational_unit.sandbox.id
}
