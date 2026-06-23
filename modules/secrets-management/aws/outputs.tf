output "kms_key_arn" {
  value       = aws_kms_key.secrets_key.arn
  description = "The ARN of the KMS key."
}

output "kms_key_id" {
  value       = aws_kms_key.secrets_key.key_id
  description = "The ID of the KMS key."
}

output "secret_arn" {
  value       = aws_secrets_manager_secret.secret.arn
  description = "The ARN of the Secrets Manager Secret."
}

output "secret_id" {
  value       = aws_secrets_manager_secret.secret.id
  description = "The ID/Name of the Secrets Manager Secret."
}
