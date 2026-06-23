variable "name_prefix" {
  type        = string
  description = "Prefix applied to names of all resources."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. production, staging, development)."
}

variable "log_group_name" {
  type        = string
  description = "The name/path of the CloudWatch Log Group."
}

variable "log_retention_days" {
  type        = number
  description = "Number of days to retain logs. Recommended >= 365 days under HIPAA."
  default     = 365
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS Key used to encrypt the Log Group."
}

variable "create_cloudtrail_delivery_role" {
  type        = bool
  description = "Set to true to create the IAM delivery role for CloudTrail logs."
  default     = false
}
