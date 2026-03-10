locals {

  groups = toset([
    for acc in values(local.accounts) :
    acc.group
    if acc.group != null
  ])

}


# Admin group for users who need full administrative access to all accounts and resources. Members of this group can be assigned permission sets that grant them full permissions across all accounts, allowing them to manage and configure resources without restrictions.
resource "aws_identitystore_group" "platform_admins" {
  identity_store_id = local.identity_store_id
  display_name      = "AWS-Admins"
}

# This group is intended for users who need permissions to develop and manage resources across accounts, but should not have full administrative access. Members of this group can be assigned permission sets that allow them to create and manage resources, but with restrictions on certain sensitive actions or services.
resource "aws_identitystore_group" "developers" {
  identity_store_id = local.identity_store_id
  display_name      = "AWS-Developers"
}

# Required for read-only access to accounts, which is a common use case for many users in an organization. This group can be assigned a permission set with read-only permissions to allow users in this group to view resources and configurations across accounts without making changes.
resource "aws_identitystore_group" "cloud_engineers" {
  

  identity_store_id = local.identity_store_id
  display_name      = "cloud-engineers"
}


resource "aws_identitystore_group" "devops" {
  

  identity_store_id = local.identity_store_id
  display_name      = "AWS-DevOps"
}



