variable "name_prefix" {
  type        = string
  description = "Prefix applied to names of all resources."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. production, staging, development)."
}

variable "description" {
  type        = string
  description = "Description for the KMS key."
}

variable "deletion_window_days" {
  type        = number
  description = "The waiting period, specified in number of days, before database key deletion is processed."
  default     = 30
}

variable "key_alias" {
  type        = string
  description = "The display name alias of the KMS key."
}

variable "allowed_services" {
  type        = list(string)
  description = "List of AWS Service principals allowed to use this key (e.g. s3.amazonaws.com)."
  default     = ["s3.amazonaws.com", "rds.amazonaws.com", "secretsmanager.amazonaws.com", "logs.amazonaws.com"]
}
