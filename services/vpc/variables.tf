variable "aws_region" {
  type        = string
  description = "The AWS region to deploy network resources in."
  default     = "us-east-1"
}

variable "name_prefix" {
  type        = string
  description = "Prefix applied to names of all resources."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. production, staging, development)."
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "az_count" {
  type        = number
  description = "Number of Availability Zones to spread subnets across."
  default     = 2
}

variable "log_retention_days" {
  type        = number
  description = "Retention period in days for VPC Flow Logs in CloudWatch."
  default     = 365
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS Key used to encrypt CloudWatch log groups."
  default     = null
}
