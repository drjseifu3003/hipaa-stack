# AWS Secrets Manager Service

This service provisions secure secret containers in AWS Secrets Manager to store sensitive API keys, DB credentials, or certificates. It aligns with **164.312(a)(1) Access Control**.

## HIPAA Compliance Features
- **SSE-KMS Encryption**: All secrets are encrypted at rest using a designated Customer Managed Key (CMK) in KMS.
- **Recovery Window**: Enforces a minimum 30-day recovery window to prevent malicious or accidental deletions of clinical access credentials.
- **VPC Endpoint Access**: Can be accessed privately within the VPC (without traversing the public internet) using a dedicated Interface VPC Endpoint.

## Usage Example

```hcl
module "db_secrets" {
  source = "github.com/momentum-ai/hipaa-stack//services/secretsmanager"

  name_prefix = "health-prod"
  environment = "production"
  secret_name = "database-credentials"
  kms_key_arn = module.kms.kms_key_arn
}
```
