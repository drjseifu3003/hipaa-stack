variable "aws_region" {
  type        = string
  description = "The AWS region to deploy compute resources in."
  default     = "us-east-1"
}

variable "name_prefix" {
  type        = string
  description = "Prefix applied to names of all resources."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. production, staging, development)."
}

variable "log_retention_days" {
  type        = number
  description = "Number of days to retain container logs in CloudWatch."
  default     = 30
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS Key used to encrypt container logs in CloudWatch."
  default     = null
}

variable "cpu" {
  type        = string
  description = "The number of cpu units used by the task (e.g. '256' for 0.25 vCPU)."
  default     = "256"
}

variable "memory" {
  type        = string
  description = "The amount of memory (in MiB) used by the task (e.g. '512')."
  default     = "512"
}

variable "container_image" {
  type        = string
  description = "Docker image to run in the Fargate container."
}

variable "container_port" {
  type        = number
  description = "The port the container listens on."
  default     = 8080
}

variable "environment_variables" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Environment variables to pass to the container."
  default     = []
}

variable "desired_count" {
  type        = number
  description = "The number of instances of the task definition to place and keep running."
  default     = 2
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Subnets to associate with the ECS Service."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the ECS Service security group will be created."
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed to access the container port."
}
