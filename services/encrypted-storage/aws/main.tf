# HIPAA-Compliant Encrypted Storage for AWS
# Aligns with HIPAA Safeguards: 164.312(a)(2)(iv) Encryption/Decryption, 164.312(c)(1) Integrity, 164.308(a)(7)(ii)(A) Data Backup Plan

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# --- KMS CMK for Storage Encryption ---
resource "aws_kms_key" "storage" {
  description             = "KMS key for encrypting PHI stored in S3"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Name        = "${var.name_prefix}-s3-key"
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}

resource "aws_kms_alias" "storage" {
  name          = "alias/${var.name_prefix}-s3-key"
  target_key_id = aws_kms_key.storage.key_id
}

# --- Main S3 Bucket for PHI ---
resource "aws_s3_bucket" "phi" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy_bucket

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}

# --- Block All Public Access ---
resource "aws_s3_bucket_public_access_block" "phi_block" {
  bucket = aws_s3_bucket.phi.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# --- S3 Versioning (Integrity & Disaster Recovery) ---
resource "aws_s3_bucket_versioning" "phi_versioning" {
  bucket = aws_s3_bucket.phi.id
  versioning_configuration {
    status = "Enabled"
  }
}

# --- Server Side Encryption (SSE-KMS) ---
resource "aws_s3_bucket_server_side_encryption_configuration" "phi_encryption" {
  bucket = aws_s3_bucket.phi.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.storage.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

# --- Bucket Access Logging ---
# Aligns with HIPAA Safeguards 164.312(b) Audit Controls
resource "aws_s3_bucket_logging" "phi_logging" {
  count  = var.logging_bucket_name != "" ? 1 : 0
  bucket = aws_s3_bucket.phi.id

  target_bucket = var.logging_bucket_name
  target_prefix = "s3-access-logs/${var.bucket_name}/"
}

# --- S3 Bucket Policy (Enforce SSL / HTTPS Only) ---
resource "aws_s3_bucket_policy" "phi_policy" {
  bucket = aws_s3_bucket.phi.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "EnforceTLSRequestsOnly"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.phi.arn,
          "${aws_s3_bucket.phi.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

# --- S3 Lifecycle Rules ---
resource "aws_s3_bucket_lifecycle_configuration_v2" "phi_lifecycle" {
  count  = var.enable_lifecycle_rules ? 1 : 0
  bucket = aws_s3_bucket.phi.id

  rule {
    id     = "archive-old-phi"
    status = "Enabled"

    noncurrent_version_transition {
      noncurrent_days = var.noncurrent_version_transition_days
      storage_class   = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }

    transition {
      days          = var.transition_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.expiration_days
    }
  }
}

# --- AWS Backup for Disaster Recovery ---
# Aligns with HIPAA Safeguard 164.308(a)(7)(ii)(A) Data Backup Plan
resource "aws_backup_vault" "vault" {
  count       = var.enable_backup ? 1 : 0
  name        = "${var.name_prefix}-backup-vault"
  kms_key_arn = aws_kms_key.storage.arn

  tags = {
    Environment = var.environment
  }
}

resource "aws_backup_plan" "plan" {
  count = var.enable_backup ? 1 : 0
  name  = "${var.name_prefix}-backup-plan"

  rule {
    rule_name         = "daily-backup"
    target_vault_name = aws_backup_vault.vault[0].name
    schedule          = "cron(0 12 * * ? *)" # Daily at 12:00 PM UTC

    lifecycle {
      delete_after = var.backup_retention_days
    }
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role" "backup" {
  count = var.enable_backup ? 1 : 0
  name  = "${var.name_prefix}-backup-role"

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
  count      = var.enable_backup ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup[0].name
}

resource "aws_iam_role_policy_attachment" "backup_restores" {
  count      = var.enable_backup ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
  role       = aws_iam_role.backup[0].name
}

resource "aws_backup_selection" "selection" {
  count        = var.enable_backup ? 1 : 0
  iam_role_arn = aws_iam_role.backup[0].arn
  name         = "${var.name_prefix}-backup-selection"
  plan_id      = aws_backup_plan.plan[0].id

  resources = [
    aws_s3_bucket.phi.arn
  ]
}
