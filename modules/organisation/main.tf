# This module sets up the AWS Organization for the landing zone. 
# It creates a new organization with the specified feature set.
# Organizations can be created with either ALL or CONSOLIDATED_BILLING feature sets. 
# For a landing zone, we recommend using ALL to take advantage of the full range of organizational features.

resource "aws_organizations_organization" "org" {
  feature_set = "ALL"   # ALL enables all features, including consolidated billing, while CONSOLIDATED_BILLING only enables consolidated billing features.
}


# Organizational Units

resource "aws_organizations_organizational_unit" "security" {
  name      = "Security"
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "infrastructure" {
  name      = "Infrastructure"
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "workloads" {
  name      = "Workloads"
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "sandbox" {
  name      = "Sandbox"
  parent_id = aws_organizations_organization.org.roots[0].id
}
 

