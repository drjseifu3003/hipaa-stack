# AWS Backup Service

This service provisions centralized backups in AWS Backup, allowing automated snapshot plans for S3 buckets, RDS databases, or DynamoDB tables. It aligns with **164.308(a)(7)(ii)(A) Data Backup Plan**.

## HIPAA Compliance Features
- **Vault Encryption**: Enforces backup snapshots to be encrypted using Customer Managed Keys (CMKs) in KMS.
- **Automated Scheduling**: Executes snapshots daily on a CRON schedule with automated lifecycle expiration rules.
- **Least-Privilege Roles**: Uses a specific IAM role dedicated to backup and restore procedures, keeping access boundaries narrow.

## Usage Example

```hcl
module "backup" {
  source = "github.com/drjseifu3003/hipaa-stack//services/backup"

  name_prefix           = "health-prod"
  environment           = "production"
  kms_key_arn           = module.kms.kms_key_arn
  backup_retention_days = 90
  backup_resources      = [
    module.s3.bucket_arn,
    module.rds.db_instance_arn
  ]
}
```
