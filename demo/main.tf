# HIPAA Stack Unified Demo Configuration
# This demo showcases all 13 security-hardened AWS modules working together:
# 1. KMS (Customer Managed Keys with rotation)
# 2. VPC (Isolated subnets, PrivateLink endpoints, Flow Logs)
# 3. WAFv2 (Web Application Firewall protection rules)
# 4. S3 (Encrypted, versioned storage for clinical records)
# 5. RDS (Multi-AZ encrypted PostgreSQL database)
# 6. Fargate (Isolated container compute tasks)
# 7. VPN (Secure EC2 Client VPN ingress)
# 8. Secrets Manager (KMS-encrypted app credentials)
# 9. CloudWatch (KMS-encrypted application logs)
# 10. CloudTrail (API & S3 data-plane activity auditing)
# 11. GuardDuty (Continuous intelligent threat monitoring)
# 12. Backup (Vault-secured automated backups for S3/RDS)
# 13. HealthLake (Native FHIR R4 clinical database datastore)

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = ">= 0.70.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "awscc" {
  region = var.aws_region
}

# -----------------------------------------------------------------------------
# Demo Variables
# -----------------------------------------------------------------------------
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

variable "db_password" {
  type        = string
  description = "Database administrator password"
  default     = "SecurePHIDatabasePass123!"
  sensitive   = true
}

# -----------------------------------------------------------------------------
# 1. Cryptographic Key Management (KMS)
# -----------------------------------------------------------------------------
module "kms" {
  source      = "github.com/drjseifu3003/hipaa-stack//services/kms?ref=feat/aws-hipaa-stack"
  name_prefix = var.name_prefix
  environment = var.environment
  description = "Primary CMK for encrypting demo patient data at rest"
  key_alias   = "phi-key"
}

# -----------------------------------------------------------------------------
# 2. Network Isolation Envelope (VPC)
# -----------------------------------------------------------------------------
module "vpc" {
  source      = "github.com/drjseifu3003/hipaa-stack//services/vpc?ref=feat/aws-hipaa-stack"
  name_prefix = var.name_prefix
  environment = var.environment
  aws_region  = var.aws_region
  vpc_cidr    = "10.0.0.0/16"
  az_count    = 2
  kms_key_arn = module.kms.kms_key_arn
}

# -----------------------------------------------------------------------------
# 3. Web Application Firewall (WAF)
# -----------------------------------------------------------------------------
module "waf" {
  source      = "github.com/drjseifu3003/hipaa-stack//services/waf?ref=feat/aws-hipaa-stack"
  name_prefix = var.name_prefix
  environment = var.environment
  scope       = "REGIONAL"
}

# -----------------------------------------------------------------------------
# 4. Protected Health Information Storage (S3)
# -----------------------------------------------------------------------------
module "s3_phi_storage" {
  source              = "github.com/drjseifu3003/hipaa-stack//services/s3?ref=feat/aws-hipaa-stack"
  bucket_name         = "${var.name_prefix}-phi-records-bucket-demo"
  environment         = var.environment
  kms_key_arn         = module.kms.kms_key_arn
  logging_bucket_name = "${var.name_prefix}-phi-access-logs-demo"
}

# -----------------------------------------------------------------------------
# 5. Secure Database Storage (RDS PostgreSQL)
# -----------------------------------------------------------------------------
module "rds_db" {
  source              = "github.com/drjseifu3003/hipaa-stack//services/rds?ref=feat/aws-hipaa-stack"
  name_prefix         = var.name_prefix
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  allowed_cidr_blocks = ["10.0.0.0/16"]
  kms_key_arn         = module.kms.kms_key_arn
  database_name       = "clinical_records"
  admin_username      = "phi_admin"
  admin_password      = var.db_password
}

# -----------------------------------------------------------------------------
# 6. Isolated Serverless Compute (ECS Fargate)
# -----------------------------------------------------------------------------
module "fargate_compute" {
  source              = "github.com/drjseifu3003/hipaa-stack//services/fargate?ref=feat/aws-hipaa-stack"
  name_prefix         = var.name_prefix
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  allowed_cidr_blocks = ["10.0.0.0/16"]
  kms_key_arn         = module.kms.kms_key_arn
  container_image     = "amazon/amazon-ecs-sample:latest"
}

# -----------------------------------------------------------------------------
# 7. Secure Ingress Connection Tunnel (Client VPN)
# -----------------------------------------------------------------------------
module "client_vpn" {
  source              = "github.com/drjseifu3003/hipaa-stack//services/vpn?ref=feat/aws-hipaa-stack"
  name_prefix         = var.name_prefix
  environment         = var.environment
  vpn_server_cert_arn = "arn:aws:acm:us-east-1:123456789012:certificate/00000000-0000-0000-0000-000000000000"
  vpn_client_cert_arn = "arn:aws:acm:us-east-1:123456789012:certificate/00000000-0000-0000-0000-000000000000"
  private_subnet_ids  = module.vpc.private_subnet_ids
  vpc_cidr            = "10.0.0.0/16"
  log_group_name      = "/aws/vpn/${var.name_prefix}-logs"
}

# -----------------------------------------------------------------------------
# 8. Encrypted Application Secrets (Secrets Manager)
# -----------------------------------------------------------------------------
module "secrets" {
  source      = "github.com/drjseifu3003/hipaa-stack//services/secretsmanager?ref=feat/aws-hipaa-stack"
  name_prefix = var.name_prefix
  environment = var.environment
  secret_name = "clinical-app-database-secrets"
  kms_key_arn = module.kms.kms_key_arn
}

# -----------------------------------------------------------------------------
# 9. Encrypted System Logging (CloudWatch Logs)
# -----------------------------------------------------------------------------
module "logs" {
  source             = "github.com/drjseifu3003/hipaa-stack//services/cloudwatch?ref=feat/aws-hipaa-stack"
  name_prefix        = var.name_prefix
  environment        = var.environment
  log_group_name     = "/aws/app/clinical-triage-service"
  kms_key_arn        = module.kms.kms_key_arn
  log_retention_days = 365
}

# -----------------------------------------------------------------------------
# 10. Audit Logging and Trail Verification (CloudTrail)
# -----------------------------------------------------------------------------
module "audit_trail" {
  source      = "github.com/drjseifu3003/hipaa-stack//services/cloudtrail?ref=feat/aws-hipaa-stack"
  name_prefix = var.name_prefix
  environment = var.environment
  kms_key_arn = module.kms.kms_key_arn
}

# -----------------------------------------------------------------------------
# 11. Security Monitoring and Intrusion Detection (GuardDuty)
# -----------------------------------------------------------------------------
module "threat_detection" {
  source      = "github.com/drjseifu3003/hipaa-stack//services/guardduty?ref=feat/aws-hipaa-stack"
  environment = var.environment
}

# -----------------------------------------------------------------------------
# 12. Disaster Recovery and Snapshots (AWS Backup)
# -----------------------------------------------------------------------------
module "vault_backups" {
  source      = "github.com/drjseifu3003/hipaa-stack//services/backup?ref=feat/aws-hipaa-stack"
  name_prefix = var.name_prefix
  environment = var.environment
  kms_key_arn = module.kms.kms_key_arn
  backup_resources = [
    module.s3_phi_storage.bucket_arn,
    module.rds_db.db_instance_arn
  ]
}

# -----------------------------------------------------------------------------
# 13. Standardized Healthcare Data Lake (AWS HealthLake)
# -----------------------------------------------------------------------------
module "fhir_healthlake" {
  source         = "github.com/drjseifu3003/hipaa-stack//services/healthlake?ref=feat/aws-hipaa-stack"
  name_prefix    = var.name_prefix
  environment    = var.environment
  datastore_name = "care-records"
  kms_key_arn    = module.kms.kms_key_arn
}

# -----------------------------------------------------------------------------
# Outputs for Demonstration
# -----------------------------------------------------------------------------
output "kms_key_arn" {
  value       = module.kms.kms_key_arn
  description = "Customer Managed Key (CMK) ARN"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "Isolated VPC ID"
}

output "s3_bucket_arn" {
  value       = module.s3_phi_storage.bucket_arn
  description = "Secure S3 Bucket ARN"
}

output "rds_db_endpoint" {
  value       = module.rds_db.db_endpoint
  description = "Encrypted RDS PostgreSQL endpoint"
}

output "fargate_cluster_name" {
  value       = module.fargate_compute.ecs_cluster_name
  description = "Secure ECS Fargate Cluster name"
}

output "healthlake_datastore_endpoint" {
  value       = module.fhir_healthlake.datastore_endpoint
  description = "FHIR HealthLake Datastore Endpoint"
}
