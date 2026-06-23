output "backup_vault_arn" {
  value       = aws_backup_vault.vault.arn
  description = "The ARN of the Backup Vault."
}

output "backup_vault_name" {
  value       = aws_backup_vault.vault.name
  description = "The Name of the Backup Vault."
}

output "backup_plan_id" {
  value       = aws_backup_plan.plan.id
  description = "The ID of the Backup Plan."
}
