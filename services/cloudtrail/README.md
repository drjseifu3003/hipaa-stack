# AWS CloudTrail Service

This service configures centralized API activity logging and auditing on AWS, aligned with **164.312(b) Audit Controls**.

## HIPAA Compliance Features
- **API and Data Logging**: Ingests all management events and S3 data-plane read/write events across your AWS account.
- **Log File Validation**: Enables hash validations on log delivery files to assure they have not been tampered with or modified.
- **SSE-KMS Encryption**: All trail files stored in S3 are encrypted at rest using a Customer Managed Key (CMK) in KMS.

## Usage Example

```hcl
module "cloudtrail" {
  source = "github.com/momentum-ai/hipaa-stack//services/cloudtrail"

  name_prefix = "health-prod"
  environment = "production"
  kms_key_arn = module.kms.kms_key_arn
}
```
