resource "aws_backup_vault" "prod" {
  provider = aws.prod
  name     = "prod-backup-vault"
}

# Enable Vault Lock (Immutable Backups)
resource "aws_backup_vault_lock_configuration" "prod_lock" {
  provider          = aws.prod
  backup_vault_name = aws_backup_vault.prod.name

  min_retention_days = 30
  max_retention_days = 90

  changeable_for_days = 7
}

# Create backup plan and assign vault
resource "aws_backup_plan" "prod_plan" {
  provider = aws.prod
  name     = "prod-backup-plan"

  rule {
    rule_name         = "daily-backups"
    target_vault_name = aws_backup_vault.prod.name
    schedule          = "cron(0 3 * * ? *)"

    lifecycle {
      delete_after = 30
    }

    copy_action {
      destination_vault_arn = aws_backup_vault.prod_dr.arn

      lifecycle {
        delete_after = 30
      }
    }
  }

  rule {
    rule_name         = "monthly-backups"
    target_vault_name = aws_backup_vault.prod.name
    schedule          = "cron(0 4 1 * ? *)"

    lifecycle {
      delete_after = 90
    }

    copy_action {
      destination_vault_arn = aws_backup_vault.prod_dr.arn

      lifecycle {
        delete_after = 90
      }
    }
  }
}

# Tag production resources: tag-based selection — best practices recommend tagging resources for backup selection 
# instead of hardcoding ARNs in the backup selection resource. This allows for dynamic inclusion of new resources 
#without needing to update the backup plan.
#tags = {
#   Backup = "true"
#   Environment = "prod"
# }
# # Backup Selection (EBS + RDS)
resource "aws_backup_selection" "prod_selection" {
  provider      = aws.prod
  name          = "prod-resource-selection"
  iam_role_arn  = aws_iam_role.backup_role.arn
  plan_id       = aws_backup_plan.prod_plan.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "true"
  }
}

#   RDS Snapshot Strategy (If Using RDS)
# If you deploy RDS in prod, make sure;
# backup_retention_period = 7
# storage_encrypted       = true
# copy_tags_to_snapshot   = true