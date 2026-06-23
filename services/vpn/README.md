# AWS Client VPN Service

This service provisions an AWS Client VPN endpoint to allow developers, administrators, and clinical staff to access resources within the private VPC subnets securely. It aligns with **164.312(a)(1) Access Control**.

## HIPAA Compliance Features
- **Secure Authentication**: Demands certificate-based authentication or MFA compatibility to prevent unauthorized network entry.
- **Connection Auditing**: Streams VPN connection event logs (successes, failures, IPs, durations) to an encrypted CloudWatch Log Group (**164.312(b) Audit Controls**).
- **Target Subnet Association**: Explicitly routes VPN traffic only to the private subnet range, preventing any outbound internet routing bypass.

## Usage Example

```hcl
module "vpn" {
  source = "github.com/momentum-ai/hipaa-stack//services/vpn"

  name_prefix         = "health-prod"
  environment         = "production"
  vpn_server_cert_arn = "arn:aws:acm:us-east-1:123456789012:certificate/abc-123"
  vpn_client_cert_arn = "arn:aws:acm:us-east-1:123456789012:certificate/xyz-789"
  private_subnet_ids  = module.vpc.private_subnet_ids
  vpc_cidr            = "10.0.0.0/16"
  log_group_name      = "/aws/vpn/logs"
}
```
