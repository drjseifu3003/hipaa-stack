# HIPAA-Compliant Audit Logging & Monitoring for AWS
# Aligns with HIPAA Safeguards: 164.312(b) Audit Controls, 164.312(c)(2) Mechanism to Authenticate PHI

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
data "aws_partition" "current" {}

# --- KMS CMK for Trail and CloudWatch Logs ---
resource "aws_kms_key" "audit" {
  description             = "KMS key for encrypting audit trails and log groups"
  deletion_window_in_days = 30
  enable_key_rotation     = true

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
        Sid    = "AllowCloudTrailToUseKey"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = [
          "kms:GenerateDataKey*",
          "kms:Decrypt"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowCloudWatchLogsToUseKey"
        Effect = "Allow"
        Principal = {
          Service = "logs.amazonaws.com"
        }
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "${var.name_prefix}-audit-key"
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}

# --- CloudTrail Logs S3 Bucket ---
resource "aws_s3_bucket" "trail_bucket" {
  bucket        = "${var.name_prefix}-trail-logs-bucket"
  force_destroy = var.force_destroy_logs

  tags = {
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}

resource "aws_s3_bucket_public_access_block" "trail_bucket_block" {
  bucket = aws_s3_bucket.trail_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "trail_bucket_policy" {
  bucket = aws_s3_bucket.trail_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.trail_bucket.arn
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.trail_bucket.arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Sid       = "EnforceTLS"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.trail_bucket.arn,
          "${aws_s3_bucket.trail_bucket.arn}/*"
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

# --- CloudWatch Log Group for Trail Stream ---
resource "aws_cloudwatch_log_group" "trail_group" {
  name              = "/aws/cloudtrail/${var.name_prefix}-trail"
  retention_in_days = var.log_retention_days
  kms_key_id        = aws_kms_key.audit.arn

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role" "trail_to_cloudwatch" {
  name = "${var.name_prefix}-trail-to-cw-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "trail_policy" {
  name = "${var.name_prefix}-trail-policy"
  role = aws_iam_role.trail_to_cloudwatch.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "${aws_cloudwatch_log_group.trail_group.arn}:*"
      }
    ]
  })
}

# --- CloudTrail (Logs all API activity including S3 Data access) ---
# Aligns with HIPAA Safeguards 164.312(b) Audit Controls
resource "aws_cloudtrail" "main" {
  name                          = "${var.name_prefix}-trail"
  s3_bucket_name                = aws_s3_bucket.trail_bucket.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true # Ensures log files are not tampered with
  kms_key_id                    = aws_kms_key.audit.arn

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.trail_group.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.trail_to_cloudwatch.arn

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }

  tags = {
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}

# --- GuardDuty Threat Detection ---
resource "aws_guardduty_detector" "detector" {
  count                        = var.enable_guardduty ? 1 : 0
  enable                       = true
  finding_publishing_frequency = "FIFTEEN_MINUTES"

  tags = {
    Environment = var.environment
  }
}
