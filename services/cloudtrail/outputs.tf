output "trail_arn" {
  value       = aws_cloudtrail.main.arn
  description = "The ARN of the CloudTrail."
}

output "trail_bucket_id" {
  value       = aws_s3_bucket.trail_bucket.id
  description = "The ID of the S3 bucket hosting CloudTrail logs."
}

output "trail_bucket_arn" {
  value       = aws_s3_bucket.trail_bucket.arn
  description = "The ARN of the S3 bucket hosting CloudTrail logs."
}
