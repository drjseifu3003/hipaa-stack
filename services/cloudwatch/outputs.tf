output "log_group_arn" {
  value       = aws_cloudwatch_log_group.log_group.arn
  description = "The ARN of the CloudWatch Log Group."
}

output "log_group_name" {
  value       = aws_cloudwatch_log_group.log_group.name
  description = "The Name of the CloudWatch Log Group."
}

output "delivery_role_arn" {
  value       = var.create_cloudtrail_delivery_role ? aws_iam_role.cloudtrail_delivery[0].arn : null
  description = "The ARN of the IAM delivery role for CloudTrail."
}
