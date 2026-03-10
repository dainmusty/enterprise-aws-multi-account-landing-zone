output "account_ids" {
  value = {
    for k, v in aws_organizations_account.accounts :
    k => v.id
  }
}