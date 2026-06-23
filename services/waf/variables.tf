variable "name_prefix" {
  type        = string
  description = "Prefix applied to names of all resources."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. production, staging, development)."
}

variable "scope" {
  type        = string
  description = "The scope of the Web ACL. Valid values are REGIONAL or CLOUDFRONT."
  default     = "REGIONAL"
}
