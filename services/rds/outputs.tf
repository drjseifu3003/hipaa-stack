output "db_instance_id" {
  value       = aws_db_instance.postgres.id
  description = "The ID of the RDS Instance."
}

output "db_instance_arn" {
  value       = aws_db_instance.postgres.arn
  description = "The ARN of the RDS Instance."
}

output "db_endpoint" {
  value       = aws_db_instance.postgres.endpoint
  description = "The connection endpoint for the database."
}

output "db_port" {
  value       = aws_db_instance.postgres.port
  description = "The port of the database."
}
