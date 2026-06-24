# HIPAA-Compliant AWS Secrets Manager Service
# Aligns with HIPAA Safeguards: 164.312(a)(1) Access Control

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_secretsmanager_secret" "secret" {
  name                    = "${var.name_prefix}-${var.secret_name}"
  description             = var.description
  kms_key_id              = var.kms_key_arn
  recovery_window_in_days = var.recovery_window_days

  tags = {
    Name        = "${var.name_prefix}-${var.secret_name}"
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}
