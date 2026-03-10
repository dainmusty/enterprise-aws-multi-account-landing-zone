resource "aws_backup_vault" "prod_dr" {
  provider = aws.prod_dr
  name     = "prod-dr-backup-vault"
}

resource "aws_backup_vault_lock_configuration" "prod_dr_lock" {
  provider          = aws.prod_dr
  backup_vault_name = aws_backup_vault.prod_dr.name

  min_retention_days = 30
  max_retention_days = 90
  changeable_for_days = 7
}