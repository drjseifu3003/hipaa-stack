output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC."
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "List of IDs of the public subnets."
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "List of IDs of the private subnets."
}

output "waf_web_acl_arn" {
  value       = var.enable_waf ? aws_wafv2_web_acl.waf[0].arn : null
  description = "The ARN of the regional WAFv2 Web ACL."
}

output "vpn_endpoint_id" {
  value       = var.enable_vpn ? aws_ec2_client_vpn_endpoint.vpn[0].id : null
  description = "The ID of the Client VPN endpoint."
}
