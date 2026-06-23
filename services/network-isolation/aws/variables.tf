variable "aws_region" {
  type        = string
  description = "The AWS region to deploy network resources into."
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

variable "enable_nat_gateway" {
  type        = bool
  description = "Set to true to provision a NAT Gateway for outbound internet access in private subnets."
  default     = true
}

variable "log_retention_days" {
  type        = number
  description = "Retention period in days for VPC Flow Logs in CloudWatch."
  default     = 365
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS Key used to encrypt CloudWatch log groups. Set to null if not using KMS encryption for CloudWatch (not recommended for production)."
  default     = null
}

variable "enable_bedrock_endpoint" {
  type        = bool
  description = "Enable Interface VPC Endpoint for AWS Bedrock Runtime."
  default     = true
}

variable "enable_vpn" {
  type        = bool
  description = "Enable AWS Client VPN for remote secure administrative access."
  default     = false
}

variable "vpn_server_cert_arn" {
  type        = string
  description = "ARN of the server certificate uploaded to ACM for Client VPN."
  default     = ""
}

variable "vpn_client_cert_arn" {
  type        = string
  description = "ARN of the client certificate uploaded to ACM for Client VPN."
  default     = ""
}

variable "vpn_client_cidr" {
  type        = string
  description = "IP range to allocate to VPN clients. Must not overlap VPC CIDR."
  default     = "172.16.0.0/22"
}

variable "enable_waf" {
  type        = bool
  description = "Whether to provision the regional WAFv2 Web ACL."
  default     = true
}
