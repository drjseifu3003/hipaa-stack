# HIPAA-Compliant AWS HealthLake FHIR Datastore
# Aligns with HIPAA Safeguards: 164.312(a)(2)(iv) Encryption/Decryption, 164.312(e)(1) Transmission Security

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# --- KMS Key for HealthLake Encryption ---
resource "aws_kms_key" "healthlake" {
  description             = "KMS Key for AWS HealthLake Datastore"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Name        = "${var.name_prefix}-healthlake-key"
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}

# --- HealthLake FHIR Datastore ---
# Aligns with HIPAA Safeguards 164.312(a)(2)(iv) Encryption & 164.312(e)(1) Transmission Security
resource "aws_healthlake_fhir_datastore" "store" {
  datastore_name = "${var.name_prefix}-${var.datastore_name}"
  datastore_type = "FHIR"

  fhir_version = "R4"

  sse_configuration {
    kms_encryption_config {
      kms_key_id = aws_kms_key.healthlake.arn
      key_type   = "CUSTOMER_MANAGED_KMS_KEY"
    }
  }

  identity_provider_configuration {
    authorization_strategy             = "SMART_ON_FHIR_V1"
    fine_grained_authorization_enabled = var.fine_grained_authorization
  }

  tags = {
    Name        = "${var.name_prefix}-fhir-store"
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}
