# Permission Sets for AWS Identity Center
locals {
  sso_instance_arn = tolist(data.aws_ssoadmin_instances.ssoadmin_instances.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.ssoadmin_instances.identity_store_ids)[0]
}

locals {

  permission_sets = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
    PowerUserAccess     = "arn:aws:iam::aws:policy/PowerUserAccess"
    DeveloperAccess     = "arn:aws:iam::aws:policy/PowerUserAccess"
    ReadOnlyAccess      = "arn:aws:iam::aws:policy/ReadOnlyAccess"
    SecurityAudit       = "arn:aws:iam::aws:policy/SecurityAudit"
  }

}

resource "aws_ssoadmin_permission_set" "permission_sets" {

  for_each = local.permission_sets

  name         = each.key
  description  = "${each.key} permission set"
  instance_arn = local.sso_instance_arn

  session_duration = "PT8H"
}

resource "aws_ssoadmin_managed_policy_attachment" "policy_attach" {

  for_each = local.permission_sets

  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.permission_sets[each.key].arn
  managed_policy_arn = each.value
}