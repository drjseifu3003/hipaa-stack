variable "name_prefix" {
  type        = string
  description = "Prefix applied to names of all resources."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. production, staging, development)."
}

variable "force_destroy_logs" {
  type        = bool
  description = "Whether to force delete the logging bucket even if it contains objects."
  default     = false
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS Key used to encrypt CloudTrail logs."
}

variable "cloudwatch_log_group_arn" {
  type        = string
  description = "The ARN of the CloudWatch Log Group to deliver CloudTrail events to (optional)."
  default     = null
}

variable "cloudwatch_logs_role_arn" {
  type        = string
  description = "The ARN of the IAM role to deliver CloudTrail events to CloudWatch (optional)."
  default     = null
}
