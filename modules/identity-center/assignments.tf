# Data Sources and Locals for Identity Center Assignments
##############################################################

#############################################
# Remote State Configuration
#############################################

locals {
  tstate_bucket = "your-bucket-name"
  tstate_region = "us-east-1"
}

data "terraform_remote_state" "org" {
  backend = "s3"

  config = {
    bucket = local.tstate_bucket
    key    = "landing-zone/org/terraform.tfstate"
    region = local.tstate_region
  }
}

data "terraform_remote_state" "ou_accounts" {
  backend = "s3"

  config = {
    bucket = local.tstate_bucket
    key    = "landing-zone/ou-accounts/terraform.tfstate"
    region = local.tstate_region
  }
}

#############################################
# Identity Center
#############################################
# Identity Center Instance Data Source
data "aws_ssoadmin_instances" "ssoadmin_instances" {}


# Fetch groups from Identity Store using alternate identifier (DisplayName) to avoid hardcoding group IDs. This allows for dynamic referencing of groups based on their display names, which is more maintainable and less error-prone than using static IDs that can change across environments or over time.
data "aws_identitystore_group" "groups" {

  for_each = local.groups

  identity_store_id = local.identity_store_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value
    }
  }

}

#############################################
# Permission Sets
#############################################

# Fetch groups from Identity Store using alternate identifier (DisplayName) to avoid hardcoding group IDs. This allows for dynamic referencing of groups based on their display names, which is more maintainable and less error-prone than using static IDs that can change across environments or over time.
data "aws_ssoadmin_permission_set" "permission_sets" {

  for_each = toset(flatten([
    for acc in values(local.accounts) :
    acc.permission_sets
  ]))

  instance_arn = local.sso_instance_arn
  name         = each.key
}

#############################################


#############################################
# Locals for Dynamic Assignments
#############################################
locals {
  workload_accounts = {
    for k, v in var.accounts :
    k => v if v.ou == "workloads"
  }
}

# Extract unique permission sets across all accounts to ensure we fetch all necessary permission sets from AWS SSO Admin. This is important for the dynamic assignment logic, as it allows us to reference the correct permission set ARNs when creating account assignments without hardcoding each permission set.
locals {

  account_files = fileset("${path.module}/../../accounts", "*.yaml")

  account_data = [
    for file in local.account_files :
    yamldecode(file("${path.module}/../../accounts/${file}"))
  ]

  accounts = {
    for acc in local.account_data :
    acc.name => {
      name            = acc.name
      email           = acc.email
      ou              = acc.ou
      owner           = acc.owner
      environment     = acc.environment
      group           = try(acc.group, null)
      permission_sets = try(acc.permission_sets, [])
    }
  }
}

# Build dynamic assignments based on account definitions
# This allows for flexible assignment of permission sets to groups across accounts without hardcoding each assignment in the Terraform configuration.
locals {

  dynamic_assignments = flatten([

    for acc_name, acc in local.accounts : [

      for ps in acc.permission_sets : {

        key            = "${acc_name}-${ps}"
        group          = acc.group
        permission_set = ps
        account_id     = data.terraform_remote_state.ou_accounts.outputs.accounts[acc_name].id
      }

    ]

  ])

}


# Convert dynamic assignments list to a map for easier access in the aws_ssoadmin_account_assignment resource
locals {

  assignments = {
    for a in local.dynamic_assignments :
    a.key => a
  }

}


# Account Assignment Resource
# Terraform automatically assigns permissions when a new YAML appears. No need to manually add new resources for each account and permission set combination. Just update the YAML files in the accounts directory, and Terraform will handle the rest during the next apply.
resource "aws_ssoadmin_account_assignment" "assignments" {

  for_each = local.assignments

  instance_arn = local.sso_instance_arn

  permission_set_arn = data.aws_ssoadmin_permission_set.permission_sets[each.value.permission_set].arn

  principal_id = data.aws_identitystore_group.groups[each.value.group].group_id

  principal_type = "GROUP"

  target_id   = each.value.account_id
  target_type = "AWS_ACCOUNT"

}


# Platform Admin Auto-Access
# Example of a static assignment for platform admins to all accounts in the OU. This can be used as a baseline or for critical permissions that should be universally applied, while the dynamic assignments handle more specific cases.
resource "aws_ssoadmin_account_assignment" "platform_admins_all_accounts" {

  for_each = var.accounts

  instance_arn       = local.sso_instance_arn
  permission_set_arn = data.aws_ssoadmin_permission_set.permission_sets["AdministratorAccess"].arn

  principal_type = "GROUP"
  principal_id   = data.aws_identitystore_group.groups["PlatformAdmins"].group_id

  target_id   = each.value.id
  target_type = "AWS_ACCOUNT"
}


