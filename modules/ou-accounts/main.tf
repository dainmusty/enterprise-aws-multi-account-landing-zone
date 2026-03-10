resource "aws_organizations_account" "accounts" {
  for_each = var.accounts

  name      = each.value.name
  email     = each.value.email
  parent_id = each.value.ou_id

  role_name = "OrganizationAccountAccessRole"

  iam_user_access_to_billing = "DENY"
  close_on_deletion          = false

  lifecycle {
    prevent_destroy = true
  }
}
