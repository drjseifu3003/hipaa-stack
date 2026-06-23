# AWS HealthLake FHIR Datastore Module

This module provisions an Amazon HealthLake FHIR (Fast Healthcare Interoperability Resources) Datastore configured for secure, HIPAA-compliant clinical data storage. It aligns with **164.312(a)(2)(iv) Encryption/Decryption** and **164.312(e)(1) Transmission Security**.

## HIPAA Compliance Features
- **Storage Encryption**: Forces server-side encryption at rest using a dedicated, customer-managed KMS key (CMK) with rotation.
- **FHIR Standard Compliance**: Deploys FHIR version R4 natively, allowing standardized healthcare exchange.
- **Fine-Grained Authorization**: Optionally enables SMART on FHIR v1 fine-grained access policies to restrict clinical data reads/writes at the resource or user tier.
- **Audit Trails**: Integrates natively with CloudTrail (via the AWS audit-logging module) to log all datastore transactions, searches, and data access.

## Usage Example

```hcl
module "fhir_store" {
  source = "github.com/momentum-ai/hipaa-stack//modules/healthcare-store/aws"

  name_prefix                = "health-stack"
  environment                = "production"
  datastore_name             = "clinical-records"
  fine_grained_authorization = true
}
```
