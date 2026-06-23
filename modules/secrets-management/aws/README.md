# AWS Secrets Management Module

This module provisions a secure encryption and secret storage environment in AWS to handle database credentials, API tokens, and private keys. It aligns with **164.312(a)(2)(iv) Encryption/Decryption** and **164.312(a)(1) Access Control**.

## HIPAA Compliance Features
- **Key Rotation Enforced**: Automatically rotates the Customer Managed Key (CMK) once per year to reduce the risk of key compromise.
- **Access Delegation Policy**: Implements a strict KMS key policy ensuring only the Root/IAM administrators can configure the key, and only Secrets Manager (and approved application roles) can decrypt values.
- **Resource Recovery Window**: Retains deleted secrets for a minimum recovery period (defaulting to 30 days) to prevent accidental loss of system-critical credentials.

## Usage Example

```hcl
module "app_secrets" {
  source = "github.com/momentum-ai/hipaa-stack//modules/secrets-management/aws"

  name_prefix          = "health-stack"
  environment          = "production"
  secret_name          = "db-credentials"
  recovery_window_days = 30
}
```
