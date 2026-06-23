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
  description = "Retention period in days for CloudWatch Log Groups."
  default     = 365
}

variable "force_destroy_logs" {
  type        = bool
  description = "Whether to force delete the logging bucket even if it contains objects."
  default     = false
}

variable "enable_guardduty" {
  type        = bool
  description = "Enable AWS GuardDuty threat detection."
  default     = true
}
