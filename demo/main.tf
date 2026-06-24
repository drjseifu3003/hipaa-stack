# HIPAA Stack Demo Configuration
# This demo showcases the core security components:
# 1. AWS KMS Customer Managed Key (CMK) with automated rotation
# 2. Hardened VPC with isolated private subnets & flow logs
# 3. Encrypted S3 Bucket with versioning, TLS enforcement, & Glacier lifecycle rules

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type        = string
  description = "AWS region for the demo resources"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
  default     = "demo"
}

variable "name_prefix" {
  type        = string
  description = "Prefix applied to names of all resources"
  default     = "hipaa-demo"
}

# -----------------------------------------------------------------------------
# 1. Cryptographic Key Management (KMS)
# -----------------------------------------------------------------------------
module "kms" {
  source      = "../services/kms"
  name_prefix = var.name_prefix
  environment = var.environment
  description = "Primary CMK for encrypting demo patient data at rest"
  key_alias   = "phi-key"
}

# -----------------------------------------------------------------------------
# 2. Network Isolation Envelope (VPC)
# -----------------------------------------------------------------------------
module "vpc" {
  source      = "../services/vpc"
  name_prefix = var.name_prefix
  environment = var.environment
  aws_region  = var.aws_region
  vpc_cidr    = "10.0.0.0/16"
  az_count    = 2
  kms_key_arn = module.kms.kms_key_arn
}

# -----------------------------------------------------------------------------
# 3. Protected Health Information Storage (S3)
# -----------------------------------------------------------------------------
module "s3_phi_storage" {
  source      = "../services/s3"
  bucket_name = "${var.name_prefix}-phi-records-bucket-demo"
  environment = var.environment
  kms_key_arn = module.kms.kms_key_arn

  # Disable lifecycle transition/expiration timers for demo purposes
  enable_lifecycle_rules = false
}

# -----------------------------------------------------------------------------
# Outputs for demonstration purposes
# -----------------------------------------------------------------------------
output "kms_key_arn" {
  value       = module.kms.kms_key_arn
  description = "The ARN of the Customer Managed Key (CMK)"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the isolated VPC envelope"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "The isolated private subnet IDs for secure workloads"
}

output "s3_bucket_arn" {
  value       = module.s3_phi_storage.s3_bucket_arn
  description = "The ARN of the secure, encrypted S3 bucket"
}
