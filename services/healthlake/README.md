# Amazon HealthLake Service

This service provisions an Amazon HealthLake FHIR (Fast Healthcare Interoperability Resources) Datastore configured for secure, HIPAA-compliant clinical data storage. It aligns with **164.312(a)(2)(iv) Encryption/Decryption** and **164.312(e)(1) Transmission Security**.

## HIPAA Compliance Features
- **Storage Encryption**: Forces server-side encryption at rest using a dedicated, Customer Managed Key (CMK) in KMS.
- **FHIR Standard Compliance**: Deploys FHIR version R4 natively, allowing standardized healthcare exchange.
- **Fine-Grained Authorization**: Supports SMART on FHIR v1 fine-grained access policies.

## Usage Example

```hcl
module "healthlake" {
  source = "github.com/momentum-ai/hipaa-stack//services/healthlake"

  name_prefix                = "health-prod"
  environment                = "production"
  datastore_name             = "clinical-records"
  kms_key_arn                = module.kms.kms_key_arn
  fine_grained_authorization = true
}
```
