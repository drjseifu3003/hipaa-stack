variable "name_prefix" {
  type        = string
  description = "Prefix applied to names of all resources."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. production, staging, development)."
}

variable "vpn_server_cert_arn" {
  type        = string
  description = "ARN of the server certificate uploaded to ACM for Client VPN."
}

variable "vpn_client_cert_arn" {
  type        = string
  description = "ARN of the client certificate uploaded to ACM for Client VPN."
}

variable "vpn_client_cidr" {
  type        = string
  description = "IP range to allocate to VPN clients. Must not overlap VPC CIDR."
  default     = "172.16.0.0/22"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs to associate with the Client VPN."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block of the VPC."
}

variable "log_group_name" {
  type        = string
  description = "CloudWatch log group name to send VPN connection logs to."
}
