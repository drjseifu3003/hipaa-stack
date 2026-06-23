output "kms_key_arn" {
  value       = aws_kms_key.audit.arn
  description = "The ARN of the KMS Key used to encrypt audit logs."
}

output "trail_bucket_id" {
  value       = aws_s3_bucket.trail_bucket.id
  description = "The ID of the S3 bucket hosting CloudTrail logs."
}

output "trail_bucket_arn" {
  value       = aws_s3_bucket.trail_bucket.arn
  description = "The ARN of the S3 bucket hosting CloudTrail logs."
}

output "cloudwatch_log_group_arn" {
  value       = aws_cloudwatch_log_group.trail_group.arn
  description = "The ARN of the CloudWatch Log Group."
}

output "trail_arn" {
  value       = aws_cloudtrail.main.arn
  description = "The ARN of the CloudTrail."
}

output "guardduty_detector_id" {
  value       = var.enable_guardduty ? aws_guardduty_detector.detector[0].id : null
  description = "The ID of the GuardDuty detector."
}
