variable "environment" {
  type        = string
  description = "Deployment environment (e.g. production, staging, development)."
}

variable "enable_detector" {
  type        = bool
  description = "Enable GuardDuty threat detection."
  default     = true
}

variable "finding_publishing_frequency" {
  type        = string
  description = "The frequency of notifications sent for findings. Valid values: FIFTEEN_MINUTES, ONE_HOUR, SIX_HOURS."
  default     = "FIFTEEN_MINUTES"
}
