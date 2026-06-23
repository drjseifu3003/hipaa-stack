variable "name_prefix" {
  type        = string
  description = "Prefix applied to names of all resources."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. production, staging, development)."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Subnets to place the DB instances in."
}

variable "allocated_storage" {
  type        = number
  default     = 20
  description = "Allocated storage size in gigabytes."
}

variable "max_allocated_storage" {
  type        = number
  default     = 100
  description = "Storage autoscaling limit in gigabytes."
}

variable "engine_version" {
  type        = string
  default     = "15.4"
  description = "PostgreSQL version."
}

variable "instance_class" {
  type        = string
  default     = "db.t4g.micro"
  description = "The database instance class."
}

variable "database_name" {
  type        = string
  description = "The name of the database."
}

variable "admin_username" {
  type        = string
  description = "Administrator username for PostgreSQL."
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Administrator password for PostgreSQL."
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC."
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed to access the database."
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS Key used to encrypt the database."
}

variable "multi_az" {
  type        = bool
  default     = true
  description = "Specifies if the RDS instance is Multi-AZ."
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Database deletion protection."
}

variable "backup_retention_days" {
  type        = number
  default     = 30
  description = "The backup retention period in days."
}
