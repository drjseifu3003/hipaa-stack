# HIPAA-Compliant Secrets Management for AWS
# Aligns with HIPAA Safeguards: 164.312(a)(2)(iv) Encryption/Decryption, 164.312(a)(1) Access Control

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_caller_identity" "current" {}

# --- KMS Customer Managed Key (CMK) ---
resource "aws_kms_key" "secrets_key" {
  description             = "KMS Key for Secrets Manager encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true # Required under HIPAA

  # Key policy enforcing least privilege access
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnableIAMUserPermissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowSecretsManagerToUseKey"
        Effect = "Allow"
        Principal = {
          Service = "secretsmanager.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "${var.name_prefix}-secrets-key"
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}

resource "aws_kms_alias" "secrets_key" {
  name          = "alias/${var.name_prefix}-secrets-key"
  target_key_id = aws_kms_key.secrets_key.key_id
}

# --- Secrets Manager Secret ---
resource "aws_secrets_manager_secret" "secret" {
  name                    = "${var.name_prefix}-${var.secret_name}"
  description             = "Encrypted secret for HIPAA database/API credentials"
  kms_key_id              = aws_kms_key.secrets_key.arn
  recovery_window_in_days = var.recovery_window_days

  tags = {
    Name        = "${var.name_prefix}-${var.secret_name}"
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}
