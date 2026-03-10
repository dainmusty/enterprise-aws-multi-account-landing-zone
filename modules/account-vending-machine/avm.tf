# Data Source to fetch Org Account details from Terraform State
data "terraform_remote_state" "org" {
  backend = "s3"

  config = {
    bucket = "your-bucket-name" #put the org-terraform-state bucket name here"
    key    = "landing-zone/org/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  org_outputs = data.terraform_remote_state.org.outputs

  ou_ids = {
    security       = local.org_outputs.security_ou_id
    infrastructure = local.org_outputs.infrastructure_ou_id
    workloads      = local.org_outputs.workloads_ou_id
    sandbox        = local.org_outputs.sandbox_ou_id
  }
}

locals {

  account_files = fileset("${path.module}/../../accounts", "*.yaml")

  account_data = [
    for file in local.account_files :
    yamldecode(file("${path.module}/../../accounts/${file}"))
  ]

  accounts = {
  for file in local.account_files :
  replace(file, ".yaml", "") =>
  yamldecode(file("${path.module}/../../accounts/${file}"))
}

}


resource "aws_organizations_account" "accounts" {
  for_each = local.accounts

  name      = each.value.name
  email     = each.value.email
  parent_id = local.ou_ids[each.value.ou]

  role_name = "OrganizationAccountAccessRole"

  tags = {
    Owner       = each.value.owner
    Environment = each.value.environment
    ManagedBy   = "Terraform"
  }
}