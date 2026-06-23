# AWS Key Management Service (KMS)

This service provisions Customer Managed Keys (CMKs) in AWS KMS to encrypt database, storage, secrets, and logging payloads. It aligns with **164.312(a)(2)(iv) Encryption/Decryption**.

## HIPAA Compliance Features
- **Key Rotation Enforced**: Automatically rotates the backing key once per year.
- **Access Policies**: Restricts decryption and key administration via strict IAM policies and principal restrictions, ensuring only specified AWS services or roles can decrypt data containing PHI.

## Usage Example

```hcl
module "kms" {
  source = "github.com/drjseifu3003/hipaa-stack//services/kms"

  name_prefix = "health-prod"
  environment = "production"
  description = "Key for database storage encryption"
  key_alias   = "rds-key"
}
```
