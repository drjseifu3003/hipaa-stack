# Amazon CloudWatch Logs Service

This service provisions Amazon CloudWatch Log Groups configured with log retention and encryption settings, aligned with **164.312(b) Audit Controls**.

## HIPAA Compliance Features
- **SSE-KMS Encryption**: Enforces encryption at rest for log payloads using Customer Managed Keys in KMS.
- **Log Retention Policy**: Enforces a minimum 365-day log retention threshold to maintain clinical audit trails.
- **Delivery Role Integration**: Optionally sets up execution roles for delivery of API logs (such as CloudTrail streams).

## Usage Example

```hcl
module "cloudwatch" {
  source = "github.com/momentum-ai/hipaa-stack//services/cloudwatch"

  name_prefix        = "health-prod"
  environment        = "production"
  log_group_name     = "/aws/app/clinical-service"
  log_retention_days = 365
  kms_key_arn        = module.kms.kms_key_arn
}
```
