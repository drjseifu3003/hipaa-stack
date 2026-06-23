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
  description = "The specific name of the secret (e.g., db-creds, api-token)."
}

variable "recovery_window_days" {
  type        = number
  description = "Number of days that AWS Secrets Manager waits before deleting the secret."
  default     = 30
}
