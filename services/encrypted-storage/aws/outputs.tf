output "bucket_id" {
  value       = aws_s3_bucket.phi.id
  description = "The ID/Name of the S3 bucket."
}

output "bucket_arn" {
  value       = aws_s3_bucket.phi.arn
  description = "The ARN of the S3 bucket."
}

output "kms_key_arn" {
  value       = aws_kms_key.storage.arn
  description = "The ARN of the KMS key used to encrypt the S3 bucket."
}

output "backup_vault_arn" {
  value       = var.enable_backup ? aws_backup_vault.vault[0].arn : null
  description = "The ARN of the AWS Backup Vault."
}
