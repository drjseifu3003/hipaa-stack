# HIPAA-Compliant Amazon CloudWatch Logs Service
# Aligns with HIPAA Safeguards: 164.312(b) Audit Controls

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# --- CloudWatch Log Group for Trails or Applications ---
resource "aws_cloudwatch_log_group" "log_group" {
  name              = var.log_group_name
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_arn

  tags = {
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}

# --- IAM Role for CloudTrail to Deliver to CloudWatch ---
resource "aws_iam_role" "cloudtrail_delivery" {
  count = var.create_cloudtrail_delivery_role ? 1 : 0
  name  = "${var.name_prefix}-cloudtrail-to-cw-role"

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

resource "aws_iam_role_policy" "cloudtrail_policy" {
  count = var.create_cloudtrail_delivery_role ? 1 : 0
  name  = "${var.name_prefix}-cloudtrail-policy"
  role  = aws_iam_role.cloudtrail_delivery[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "${aws_cloudwatch_log_group.log_group.arn}:*"
      }
    ]
  })
}
