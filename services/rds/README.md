# Amazon RDS (Relational Database Service)

This service provisions an encrypted, Multi-AZ PostgreSQL Database on Amazon RDS, designed to securely house healthcare data and PHI. It aligns with **164.312(a)(2)(iv) Encryption/Decryption** and **164.308(a)(7)(ii)(A) Data Backup Plan**.

## HIPAA Compliance Features
- **Storage Encryption**: Enforces full storage encryption at rest utilizing a dedicated Customer Managed Key (CMK) in KMS.
- **Private Subnet Deployment**: Deploys the database within private VPC subnets with no public internet ingress options.
- **Access Control & Auditing**: Enables IAM Database Authentication for token-based access. Integrates Performance Insights (encrypted with KMS) to track query performance and access metrics.
- **High Availability & Disaster Recovery (Multi-AZ)**: Synchronously replicates data to a standby instance in a different Availability Zone.

## Usage Example

```hcl
module "rds" {
  source = "github.com/drjseifu3003/hipaa-stack//services/rds"

  name_prefix         = "health-prod"
  environment         = "production"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  allowed_cidr_blocks = module.vpc.private_subnet_ids
  kms_key_arn         = module.kms.kms_key_arn

  database_name       = "clinical_db"
  admin_username      = "db_admin"
  admin_password      = var.db_password
}
```
