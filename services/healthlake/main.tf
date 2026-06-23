# HIPAA-Compliant AWS HealthLake Service
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

resource "aws_healthlake_fhir_datastore" "store" {
  datastore_name = "${var.name_prefix}-${var.datastore_name}"
  datastore_type = "FHIR"

  fhir_version = "R4"

  sse_configuration {
    kms_encryption_config {
      kms_key_id = var.kms_key_arn
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
