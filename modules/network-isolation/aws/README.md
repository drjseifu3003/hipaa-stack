# AWS Network Isolation Module

This module deploys a secure, multi-AZ networking foundation on AWS designed to meet HIPAA Technical Safeguards, specifically **164.312(a)(1) Access Control** and **164.312(e)(1) Transmission Security**.

## HIPAA Compliance Features
- **Strict Network Segmentation**: Isolates workloads by separating public-facing ingress and routing from private database and compute tiers (using public/private subnets and default-deny security groups).
- **VPC Flow Logs**: Captures detailed network telemetry. Logs are sent to an encrypted CloudWatch Log Group with configurable retention (defaulting to 365 days) for auditability (**164.312(b) Audit Controls**).
- **Private API Connectivity**: Interface VPC Endpoints (AWS PrivateLink) are created for S3, KMS, Secrets Manager, and Bedrock. This prevents traffic targeting these APIs containing PHI from traversing the public internet.
- **WAFv2 Web ACL**: Optional regional WAFv2 instance pre-configured with AWS Managed Rules (Core Rule Set, SQL Injection, and Known Bad Inputs) to shield workloads against web-based exploits.
- **Client VPN Endpoint**: Optional secure VPN configured to allow administrators and clinical operators to access resources within the private subnet tiers securely.

## Usage Example

```hcl
module "network" {
  source = "github.com/momentum-ai/hipaa-stack//modules/network-isolation/aws"

  name_prefix             = "health-prod"
  environment             = "production"
  aws_region              = "us-east-1"
  vpc_cidr                = "10.0.0.0/16"
  az_count                = 2
  enable_nat_gateway      = true
  enable_bedrock_endpoint = true
  enable_waf              = true
}
```
