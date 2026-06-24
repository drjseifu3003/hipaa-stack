# HIPAA Stack Demo Configuration
# This demo showcases a single, highly secure, HIPAA-compliant S3 storage service.
# It is configured in 100% offline mock mode:
# - No active AWS credentials or account are required.
# - Running `terraform plan` will succeed instantly with zero network calls.

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# -----------------------------------------------------------------------------
# Mocked AWS Provider (Allows 100% offline speculative planning)
# -----------------------------------------------------------------------------
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
}

# -----------------------------------------------------------------------------
# Protected Health Information Storage (S3)
# -----------------------------------------------------------------------------
module "s3_phi_storage" {
  source      = "github.com/drjseifu3003/hipaa-stack//services/s3?ref=feat/aws-hipaa-stack"
  bucket_name = "hipaa-demo-phi-records-bucket"
  environment = "demo"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/00000000-0000-0000-0000-000000000000"
}

# -----------------------------------------------------------------------------
# Outputs for demonstration purposes
# -----------------------------------------------------------------------------
output "s3_bucket_arn" {
  value       = module.s3_phi_storage.bucket_arn
  description = "The ARN of the secure, encrypted S3 bucket"
}
