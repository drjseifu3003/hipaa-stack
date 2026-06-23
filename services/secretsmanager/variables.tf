variable "name_prefix" {
  type        = string
  description = "Prefix applied to names of all resources."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. production, staging, development)."
}

variable "secret_name" {
  type        = string
  description = "The specific name of the secret."
}

variable "description" {
  type        = string
  description = "Description for the secret."
  default     = "HIPAA-compliant secret container"
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS Key used to encrypt the secret."
}

variable "recovery_window_days" {
  type        = number
  description = "Number of days that AWS Secrets Manager waits before deleting the secret."
  default     = 30
}
