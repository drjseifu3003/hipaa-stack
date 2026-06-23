variable "bucket_name" {
  type        = string
  description = "The globally unique name of the S3 bucket."
}

variable "name_prefix" {
  type        = string
  description = "Prefix applied to names of all resources."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. production, staging, development)."
}

variable "force_destroy_bucket" {
  type        = bool
  description = "Whether to force destroy the bucket even if it contains objects (not recommended for production)."
  default     = false
}

variable "logging_bucket_name" {
  type        = string
  description = "Name of the S3 bucket to deliver access logs to. Highly recommended under HIPAA."
  default     = ""
}

variable "enable_lifecycle_rules" {
  type        = bool
  description = "Whether to enable lifecycle configurations (Glacier archiving and deletion)."
  default     = true
}

variable "transition_days" {
  type        = number
  description = "Number of days before transitioning current objects to Glacier."
  default     = 90
}

variable "expiration_days" {
  type        = number
  description = "Number of days before current objects expire/delete."
  default     = 365
}

variable "noncurrent_version_transition_days" {
  type        = number
  description = "Number of days before transitioning noncurrent objects to Glacier."
  default     = 30
}

variable "noncurrent_version_expiration_days" {
  type        = number
  description = "Number of days before noncurrent objects expire/delete."
  default     = 90
}

variable "enable_backup" {
  type        = bool
  description = "Enable automatic AWS Backup configuration."
  default     = true
}

variable "backup_retention_days" {
  type        = number
  description = "Number of days to keep backups in the backup vault."
  default     = 90
}
