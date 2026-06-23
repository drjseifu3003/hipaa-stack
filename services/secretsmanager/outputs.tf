output "secret_arn" {
  value       = aws_secrets_manager_secret.secret.arn
  description = "The ARN of the Secrets Manager Secret."
}

output "secret_id" {
  value       = aws_secrets_manager_secret.secret.id
  description = "The ID/Name of the Secrets Manager Secret."
}
