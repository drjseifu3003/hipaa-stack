# AWS Encrypted Storage Module

This module provisions an AWS S3 bucket configured for secure, HIPAA-compliant storage of Protected Health Information (PHI). It aligns with **164.312(a)(2)(iv) Encryption/Decryption**, **164.312(c)(1) Integrity**, and **164.308(a)(7)(ii)(A) Data Backup Plan**.

## HIPAA Compliance Features
- **Customer Managed Key (CMK) Encryption**: Forces Server-Side Encryption (SSE-KMS) with key rotation enabled using a dedicated KMS Key.
- **Enforced Secure Transport**: The bucket policy explicitly denies any unencrypted HTTP requests (`aws:SecureTransport = false`).
- **Blocked Public Access**: Enforces AWS S3 Public Access Block configurations, preventing anyone from accidentally exposing objects publicly via ACLs or bucket policies.
- **Object Versioning**: Keeps historical records of modified or deleted items to assure data integrity and support audit trail verification.
- **Audit Logging**: Logs access activity (reading/writing files) to an auxiliary secure storage bucket.
- **Disaster Recovery (AWS Backup)**: Automatically enrolls the S3 bucket in daily backup plans to a dedicated backup vault with customizable retention.

## Usage Example

```hcl
module "phi_storage" {
  source = "github.com/momentum-ai/hipaa-stack//modules/encrypted-storage/aws"

  name_prefix         = "health-stack"
  environment         = "production"
  bucket_name         = "my-phi-storage-bucket-prod"
  logging_bucket_name = "my-audit-logging-bucket"
  enable_backup       = true
}
```
