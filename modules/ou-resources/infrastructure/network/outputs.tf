output "vpc_core_id" {
  value = aws_vpc.core.id
}

output "subnet_core_private_a_id" {
  value = aws_subnet.core_private_a.id
}

output "subnet_core_private_b_id" {
  value = aws_subnet.core_private_b.id
}

output "security_group_resolver_sg_id" {
  value = aws_security_group.resolver_sg.id
}

output "resolver_endpoint_inbound_id" {
  value = aws_route53_resolver_endpoint.inbound.id
}

output "resolver_endpoint_outbound_id" {
  value = aws_route53_resolver_endpoint.outbound.id
}

output "route53_zone_internal_id" {
  value = aws_route53_zone.internal.id
}

output "route53_zone_internal_arn" {
  value = aws_route53_zone.internal.arn
}

output "ram_resource_share_dns_share_id" {
  value = aws_ram_resource_share.dns_share.id
}

output "ram_principal_association_dev_id" {
  value = aws_ram_principal_association.dev.id
}

output "ram_resource_association_zone_id" {
  value = aws_ram_resource_association.zone.id
}

output "subnet_firewall_a_id" {
  value = aws_subnet.firewall_a.id
}

output "subnet_firewall_b_id" {
  value = aws_subnet.firewall_b.id
}

output "networkfirewall_policy_id" {
  value = aws_networkfirewall_firewall_policy.policy.id
}

output "networkfirewall_firewall_core_fw_id" {
  value = aws_networkfirewall_firewall.core_fw.id
}

output "transit_gateway_enterprise_id" {
  value = aws_ec2_transit_gateway.enterprise.id
}


