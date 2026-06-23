variable "bucket_name" {
  type        = string
  description = "The globally unique name of the S3 bucket."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. production, staging, development)."
}

variable "force_destroy_bucket" {
  type        = bool
  description = "Whether to force destroy the bucket even if it contains objects."
  default     = false
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS Key used to encrypt S3 storage."
}

variable "logging_bucket_name" {
  type        = string
  description = "Name of the S3 bucket to deliver access logs to."
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
