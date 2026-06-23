variable "name_prefix" {
  type        = string
  description = "Prefix applied to names of all resources."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. production, staging, development)."
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS Key used to encrypt the backup vault."
}

variable "backup_schedule" {
  type        = string
  description = "A CRON expression specifying when AWS Backup makes a backup."
  default     = "cron(0 12 * * ? *)" # Daily at 12:00 PM UTC
}

variable "backup_retention_days" {
  type        = number
  description = "The number of days to keep backups before deletion."
  default     = 90
}

variable "backup_resources" {
  type        = list(string)
  description = "ARNs of AWS resources to back up."
}
