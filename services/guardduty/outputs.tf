output "guardduty_detector_id" {
  value       = aws_guardduty_detector.detector.id
  description = "The ID of the GuardDuty detector."
}
