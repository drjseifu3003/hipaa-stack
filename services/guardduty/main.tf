# HIPAA-Compliant AWS GuardDuty Service
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

resource "aws_guardduty_detector" "detector" {
  enable                       = var.enable_detector
  finding_publishing_frequency = var.finding_publishing_frequency

  tags = {
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}
