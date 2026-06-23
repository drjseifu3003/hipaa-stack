# HIPAA-Compliant AWS Client VPN Service
# Aligns with HIPAA Safeguards: 164.312(a)(1) Access Control

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_ec2_client_vpn_endpoint" "vpn" {
  description            = "Secure Client VPN for HIPAA Compliant Access"
  server_certificate_arn = var.vpn_server_cert_arn
  client_cidr_block      = var.vpn_client_cidr

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.vpn_client_cert_arn
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = var.log_group_name
    cloudwatch_log_stream = "vpn-connections"
  }

  tags = {
    Name        = "${var.name_prefix}-vpn"
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}

resource "aws_ec2_client_vpn_network_association" "vpn_assoc" {
  count                  = length(var.private_subnet_ids)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id              = var.private_subnet_ids[count.index]
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  target_network_cidr    = var.vpc_cidr
  authorize_all_groups   = true
}
