# HIPAAStack

**AWS compliance-first infrastructure for healthcare AI systems.**

## What is HIPAAStack?

While manually provisioning a single server is simple, scaling your application and business can lead to repetitive and time-consuming tasks. HIPAAStack solves this by providing battle-tested, production-ready Infrastructure as Code (IaC) services organized around **compliance problems** on Amazon Web Services (AWS). 

Each service is built to satisfy specific HIPAA / PIPA / PIPEDA technical safeguards, with the security and compliance reasoning documented inline in the code itself, not just in external documentation.

Built from real-world clinical client work: AI voice triage systems, legacy EMR integrations with no public APIs, multi-tenant clinical platforms, and conversational AI agents handling Protected Health Information (PHI) directly.

---

## Service Status (AWS)

| Service Name | Status | Included AWS Services / Resources |
| :--- | :---: | :--- |
| **[`services/vpc`](./services/vpc)** | ✅ Available | VPC, Private Subnets, NAT Gateways, Route Tables, VPC Endpoints |
| **[`services/vpn`](./services/vpn)** | ✅ Available | AWS Client VPN, Network Associations, Client Authorizations |
| **[`services/waf`](./services/waf)** | ✅ Available | AWS WAFv2, Web ACL, Managed rules (SQLi, OWASP CRS) |
| **[`services/s3`](./services/s3)** | ✅ Available | S3 Buckets, SSE-KMS, Versioning, Access Logging, Bucket Policies |
| **[`services/kms`](./services/kms)** | ✅ Available | Customer Managed KMS Keys (with Rotation), Key Policies |
| **[`services/secretsmanager`](./services/secretsmanager)** | ✅ Available | Secrets Manager Secrets, KMS Encryption |
| **[`services/cloudtrail`](./services/cloudtrail)** | ✅ Available | CloudTrail Trail (Management & Data events), Log File Validation |
| **[`services/cloudwatch`](./services/cloudwatch)** | ✅ Available | CloudWatch Logs, Log Groups, Log Encryption |
| **[`services/guardduty`](./services/guardduty)** | ✅ Available | GuardDuty Detector, Threat Intelligence |
| **[`services/backup`](./services/backup)** | ✅ Available | AWS Backup Vault, Backup Plans, schedules, Backup Selection |
| **[`services/rds`](./services/rds)** | ✅ Available | RDS PostgreSQL, Storage Encryption, Multi-AZ, Performance Insights |
| **[`services/fargate`](./services/fargate)** | ✅ Available | ECS Fargate Cluster, Task Definitions, ECS Services, task roles |
| **[`services/healthlake`](./services/healthlake)** | ✅ Available | HealthLake FHIR R4 Datastore, SMART on FHIR authorization |

---

## Beyond Infrastructure — The Application Layer

Infrastructure is necessary but not sufficient. A perfectly encrypted VPC doesn't stop a developer from pasting a patient's name into an AI prompt. The `patterns/` and `skill/` directories cover the application-layer problems infrastructure-as-code can't solve on its own:

- **[`patterns/emr-without-public-api.md`](./patterns/emr-without-public-api.md)** — Securely integrate with legacy EMRs using VPN tunnels, Local Gateway Agents, and HL7 v2/v3 message streams.
- **[`patterns/deterministic-triage-scoring.md`](./patterns/deterministic-triage-scoring.md)** — Keep AI out of autonomous clinical decision making. Use LLMs to extract structured variables, and run deterministic code logic for clinical triage action.
- **[`patterns/phi-tokenization-for-llm-prompts.md`](./patterns/phi-tokenization-for-llm-prompts.md)** — Prevent PHI from ever leaving your private cloud environment by tokenizing names, dates, and MRNs, calling the LLM, and detokenizing responses locally.
- **[`patterns/voice-ai-phi-handling.md`](./patterns/voice-ai-phi-handling.md)** — Architectural guidelines for Vapi/Twilio-style voice AI systems processing audio streams in real time over secure WebSockets.
- **[`skill/SKILL.md`](./skill/SKILL.md)** — Cursor/Claude developer skill configuration to automatically enforce these rules during AWS development.

---

## Quick Start Example (AWS)

```hcl
# 1. Setup secure KMS keys
module "kms" {
  source      = "github.com/momentum-ai/hipaa-stack//services/kms"
  name_prefix = "clinic-prod"
  environment = "production"
  description = "Encryption key for PHI"
  key_alias   = "phi-key"
}

# 2. Setup isolated networking VPC
module "vpc" {
  source      = "github.com/momentum-ai/hipaa-stack//services/vpc"
  name_prefix = "clinic-prod"
  environment = "production"
}

# 3. Setup S3 storage for PHI with encryption
module "storage" {
  source      = "github.com/momentum-ai/hipaa-stack//services/s3"
  bucket_name = "clinic-phi-records-bucket"
  environment = "production"
  kms_key_arn = module.kms.kms_key_arn
}

# 4. Setup audit trail
module "cloudtrail" {
  source      = "github.com/momentum-ai/hipaa-stack//services/cloudtrail"
  name_prefix = "clinic-prod"
  environment = "production"
  kms_key_arn = module.kms.kms_key_arn
}
```

See each service's respective directory for full configuration details and variables.

---

## Compliance Mapping

See **[`docs/compliance-mapping.md`](./docs/compliance-mapping.md)** for a full breakdown mapping the HIPAA Technical Safeguards (164.312) to specific AWS resources configured in these services.

---

## What This is Not

This repository does not make your application "HIPAA compliant" by itself. No infrastructure code can. You still need:
- Signed Business Associate Agreements (BAAs) with AWS and every third-party vendor.
- Process controls, staff training, and breach notification procedures.
- A real risk assessment specific to your application and deployment.
- Legal review appropriate to your jurisdiction.

---

## Contributing

We welcome contributions from the healthcare security and developer communities! Open issues and PRs to:
- Add more clinical AI pattern architectures.
- Improve compliance checks and automated AWS security validations.

---

## License

MIT - See [LICENSE](LICENSE) for details.
