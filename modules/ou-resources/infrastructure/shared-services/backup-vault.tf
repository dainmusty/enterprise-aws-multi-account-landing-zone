# Centralized Backup Strategy
resource "aws_backup_vault" "central" {
  provider = aws.shared_services
  name     = "central-backup-vault"
}