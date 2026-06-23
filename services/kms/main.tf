# HIPAA-Compliant AWS Key Management Service (KMS)
# Aligns with HIPAA Safeguards: 164.312(a)(2)(iv) Encryption/Decryption

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

resource "aws_kms_key" "key" {
  description             = var.description
  deletion_window_in_days = var.deletion_window_days
  enable_key_rotation     = true # Mandatory under HIPAA

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnableIAMAdminPermissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowServiceUsage"
        Effect = "Allow"
        Principal = {
          Service = var.allowed_services
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey*",
          "kms:Encrypt",
          "kms:ReEncrypt*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "${var.name_prefix}-key"
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}

resource "aws_kms_alias" "key" {
  name          = "alias/${var.name_prefix}-${var.key_alias}"
  target_key_id = aws_kms_key.key.key_id
}
