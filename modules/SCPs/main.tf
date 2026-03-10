# This module creates Service Control Policies (SCPs) for the AWS Organization.
# It retrieves necessary information from the organization stack and 
# then uses that information to create SCPs that enforce security best practices across the organization.

# SCPs are a powerful tool in AWS Organizations that allow you to define permission guardrails for your accounts.
# By attaching SCPs to organizational units (OUs) or accounts, you can restrict the actions that can be performed, even if the account has full permissions.
# In this example, we will create an SCP that prevents disabling or deleting CloudTrail, which is a critical service for auditing and monitoring in AWS.

# The SCP will be attached to the workloads OU, ensuring that all accounts within that OU are protected by this policy.
# SCP - Deny CloudTrail Disable: This SCP prevents any user or role in the attached accounts from disabling or deleting CloudTrail trails. 
# This is crucial for maintaining visibility into account activity and ensuring compliance with security best practices.

locals {
  policies = fileset("${path.module}/policies", "*.json")

}

resource "aws_organizations_policy" "scp" {
  for_each = var.policy_contents

  name        = replace(each.key, ".json", "")
  description = "SCP for ${each.key}"
  content     = each.value
  type        = "SERVICE_CONTROL_POLICY"
}

resource "aws_organizations_policy_attachment" "attach" {
  for_each = var.policy_to_ou

  policy_id = aws_organizations_policy.scp[each.key].id
  target_id = var.ou_ids[each.value]
}


