# AWS RDS PostgreSQL Database Module

This module provisions an encrypted, Multi-AZ PostgreSQL Database on Amazon RDS, designed to securely house healthcare data and PHI. It aligns with **164.312(a)(2)(iv) Encryption/Decryption** and **164.308(a)(7)(ii)(A) Data Backup Plan**.

## HIPAA Compliance Features
- **Storage Encryption**: Enforces full storage encryption at rest utilizing a dedicated Customer Managed Key (CMK) in KMS.
- **Private Subnet Deployment**: Deploys the database within private VPC subnets with no public internet ingress options.
- **Access Control & Auditing**: Enables IAM Database Authentication for token-based, passwordless access. Integrates Performance Insights (encrypted with KMS) to track query performance and access metrics.
- **High Availability & Disaster Recovery (Multi-AZ)**: Synchronously replicates data to a standby instance in a different Availability Zone to protect against data loss.
- **Automated Backups**: Configures automatic daily snapshots with a customizable retention period (defaulting to 30 days) to prevent accidental loss or ransomware lockouts.
- **Deletion Protection**: Activates deletion protection by default to safeguard clinical data sets.

## Usage Example

```hcl
module "rds_database" {
  source = "github.com/momentum-ai/hipaa-stack//modules/database/aws"

  name_prefix         = "health-stack"
  environment         = "production"
  vpc_id              = module.network.vpc_id
  private_subnet_ids  = module.network.private_subnet_ids
  allowed_cidr_blocks = module.network.private_subnet_ids

  database_name       = "phi_db"
  admin_username      = "db_admin"
  admin_password      = var.secret_password # Pass from secrets manager
  multi_az            = true
  deletion_protection = true
}
```
