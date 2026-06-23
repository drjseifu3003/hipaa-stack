# Amazon S3 (Simple Storage Service)

This service provisions an Amazon S3 bucket configured for secure, HIPAA-compliant storage of Protected Health Information (PHI). It aligns with **164.312(a)(2)(iv) Encryption/Decryption**, **164.312(c)(1) Integrity**, and **164.312(e)(1) Transmission Security**.

## HIPAA Compliance Features
- **SSE-KMS Encryption**: Mandates server-side encryption with Customer Managed Keys in KMS.
- **SSL-Only Transport Enforced**: Bucket policy denies requests that do not use HTTPS (`aws:SecureTransport = false`).
- **Blocked Public Access**: Prevents accidental exposure of objects via ACLs or bucket policies.
- **Object Versioning**: Records modifications and deletions to maintain data integrity and support audit verification.
- **Access Logging**: Logs file accesses to a designated audit bucket.

## Usage Example

```hcl
module "s3" {
  source = "github.com/drjseifu3003/hipaa-stack//services/s3"

  bucket_name         = "clinic-phi-records-prod"
  environment         = "production"
  kms_key_arn         = module.kms.kms_key_arn
  logging_bucket_name = "clinic-audit-logs"
}
```
