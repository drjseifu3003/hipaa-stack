# HIPAA-Compliant S3 Storage Service
# Aligns with HIPAA Safeguards: 164.312(a)(2)(iv) Encryption/Decryption, 164.312(c)(1) Integrity, 164.312(e)(1) Transmission Security

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_s3_bucket" "phi" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy_bucket

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}

resource "aws_s3_bucket_public_access_block" "phi_block" {
  bucket = aws_s3_bucket.phi.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "phi_versioning" {
  bucket = aws_s3_bucket.phi.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "phi_encryption" {
  bucket = aws_s3_bucket.phi.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_logging" "phi_logging" {
  count  = var.logging_bucket_name != "" ? 1 : 0
  bucket = aws_s3_bucket.phi.id

  target_bucket = var.logging_bucket_name
  target_prefix = "s3-access-logs/${var.bucket_name}/"
}

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
