output "waf_web_acl_id" {
  value       = aws_wafv2_web_acl.waf.id
  description = "The ID of the WAFv2 Web ACL."
}

output "waf_web_acl_arn" {
  value       = aws_wafv2_web_acl.waf.arn
  description = "The ARN of the WAFv2 Web ACL."
}
