output "vpn_endpoint_id" {
  value       = aws_ec2_client_vpn_endpoint.vpn.id
  description = "The ID of the Client VPN endpoint."
}

output "vpn_endpoint_dns_name" {
  value       = aws_ec2_client_vpn_endpoint.vpn.dns_name
  description = "The DNS name of the Client VPN endpoint."
}
