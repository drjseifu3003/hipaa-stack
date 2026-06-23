# HIPAA-Compliant AWS Backup Service
# Aligns with HIPAA Safeguards: 164.308(a)(7)(ii)(A) Data Backup Plan

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_backup_vault" "vault" {
  name        = "${var.name_prefix}-backup-vault"
  kms_key_arn = var.kms_key_arn

  tags = {
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}

resource "aws_backup_plan" "plan" {
  name = "${var.name_prefix}-backup-plan"

  rule {
    rule_name         = "daily-backup"
    target_vault_name = aws_backup_vault.vault.name
    schedule          = var.backup_schedule

    lifecycle {
      delete_after = var.backup_retention_days
    }
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role" "backup" {
  name = "${var.name_prefix}-backup-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backup" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup.name
}

resource "aws_iam_role_policy_attachment" "backup_restores" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
  role       = aws_iam_role.backup.name
}

resource "aws_backup_selection" "selection" {
  iam_role_arn = aws_iam_role.backup.arn
  name         = "${var.name_prefix}-backup-selection"
  plan_id      = aws_backup_plan.plan.id

  resources = var.backup_resources
}
