output "kms_key_arn" {
  value       = aws_kms_key.key.arn
  description = "The ARN of the KMS key."
}

output "kms_key_id" {
  value       = aws_kms_key.key.key_id
  description = "The ID of the KMS key."
}

output "kms_alias_arn" {
  value       = aws_kms_alias.key.arn
  description = "The ARN of the KMS key alias."
}
