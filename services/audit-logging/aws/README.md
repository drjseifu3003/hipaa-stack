# AWS Audit Logging Service

This service configures centralized audit trail capture and monitoring on AWS, aligned with **164.312(b) Audit Controls** and **164.312(c)(2) Mechanism to Authenticate PHI**.

## HIPAA Compliance Features
- **CloudTrail API Ingestion**: Captures all AWS API activities, including write operations, data-plane events (such as S3 file additions/downloads), and permission updates.
- **Log File Validation**: Ensures any tampering with stored log payloads is mathematically detectable (log file validation enabled).
- **Log Encryption**: Encrypts logs at rest using a customer-managed KMS key.
- **CloudWatch logs Streaming**: Relays CloudTrail events to CloudWatch Logs for real-time security scanning and retention.
- **Threat Monitoring (GuardDuty)**: Optionally deploys an AWS GuardDuty detector to run continuous threat scanning against malicious behavior or compromised API keys.

## Usage Example

```hcl
module "audit_logs" {
  source = "github.com/momentum-ai/hipaa-stack//services/audit-logging/aws"

  name_prefix        = "health-stack"
  environment        = "production"
  log_retention_days = 365
  enable_guardduty   = true
}
```
