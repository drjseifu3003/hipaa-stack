# Amazon VPC (Virtual Private Cloud) Service

This service provisions a secure, multi-AZ network environment on AWS designed to meet HIPAA Technical Safeguards, specifically **164.312(a)(1) Access Control** and **164.312(e)(1) Transmission Security**.

## HIPAA Compliance Features
- **Strict Network Segmentation**: Isolates clinical workloads inside private subnets, completely restricting direct inbound access from the public internet.
- **VPC Flow Logs**: Captures detailed network connection telemetry. Logs are sent to an encrypted CloudWatch Log Group for auditing purposes (**164.312(b) Audit Controls**).
- **Private API Connectivity (PrivateLink)**: Interface VPC Endpoints are created for S3, KMS, Secrets Manager, and Bedrock. This prevents traffic targeting these APIs containing PHI from routing over the public internet.

## Usage Example

```hcl
module "vpc" {
  source = "github.com/drjseifu3003/hipaa-stack//services/vpc"

  name_prefix = "health-prod"
  environment = "production"
  vpc_cidr    = "10.0.0.0/16"
  az_count    = 2
}
```
