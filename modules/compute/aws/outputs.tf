output "ecs_cluster_id" {
  value       = aws_ecs_cluster.cluster.id
  description = "The ID of the ECS Cluster."
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.cluster.name
  description = "The Name of the ECS Cluster."
}

output "ecs_service_name" {
  value       = aws_ecs_service.service.name
  description = "The name of the ECS Service."
}

output "ecs_task_role_arn" {
  value       = aws_iam_role.ecs_task_role.arn
  description = "The ARN of the ECS task IAM role."
}
