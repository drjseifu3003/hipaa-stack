output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC."
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "List of IDs of the public subnets."
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "List of IDs of the private subnets."
}

output "vpc_flow_log_group_arn" {
  value       = aws_cloudwatch_log_group.flow_log.arn
  description = "The ARN of the VPC flow log group."
}
