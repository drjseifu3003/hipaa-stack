# HIPAAStack

**AWS compliance-first infrastructure for healthcare AI systems.**

## What is HIPAAStack?

While manually provisioning a single server is simple, scaling your application and business can lead to repetitive and time-consuming tasks. HIPAAStack solves this by providing battle-tested, production-ready Infrastructure as Code (IaC) services organized around **compliance problems** on Amazon Web Services (AWS). 

Each service is built to satisfy specific HIPAA / PIPA / PIPEDA technical safeguards, with the security and compliance reasoning documented inline in the code itself, not just in external documentation.

Built from real-world clinical client work: AI voice triage systems, legacy EMR integrations with no public APIs, multi-tenant clinical platforms, and conversational AI agents handling Protected Health Information (PHI) directly.

---

## Service Status (AWS)

| Problem / Domain | Status | Included AWS Services / Resources |
| :--- | :---: | :--- |
| **Network Isolation** | ✅ Available | VPC, Private Subnets, NAT Gateways, Route Tables, WAFv2, Client VPN |
| **Encrypted Storage** | ✅ Available | S3 Buckets, KMS CMK, S3 Versioning, Access Logging, AWS Backup |
| **Secrets Management** | ✅ Available | KMS Keys (with Rotation), Secrets Manager Secrets |
| **Audit Logging** | ✅ Available | CloudTrail Trail (Management & Data events), CloudWatch Logs, GuardDuty |
| **Database / Healthcare Store** | ✅ Available | RDS PostgreSQL, AWS HealthLake (FHIR Datastore) |
| **Compute Services** | ✅ Available | ECS Fargate Serverless Compute, Security Groups, IAM Task Roles |
| **Identity & Access** | 🔜 Coming Soon | IAM Policies, IAM Roles, Least-privilege Access Control |
| **AI Agent Guardrails** | 🔜 Coming Soon | Bedrock Guardrails, Content Filtering |

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
# 1. Setup isolated networking and WAF protection
module "network" {
  source = "github.com/momentum-ai/hipaa-stack//services/network-isolation/aws"

  name_prefix             = "clinic-prod"
  environment             = "production"
  aws_region              = "us-east-1"
  vpc_cidr                = "10.0.0.0/16"
  enable_nat_gateway      = true
  enable_waf              = true
}

# 2. Setup S3 storage for PHI with encryption & automatic daily backups
module "storage" {
  source = "github.com/momentum-ai/hipaa-stack//services/encrypted-storage/aws"

  name_prefix         = "clinic-prod"
  environment         = "production"
  bucket_name         = "clinic-phi-records-bucket"
  logging_bucket_name = "clinic-logs-bucket"
  enable_backup       = true
}

# 3. Setup central audit trails & GuardDuty threat detection
module "audit_logs" {
  source = "github.com/momentum-ai/hipaa-stack//services/audit-logging/aws"

  name_prefix        = "clinic-prod"
  environment        = "production"
  log_retention_days = 365
  enable_guardduty   = true
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
- Organizational policies, staff training, and breach notification procedures.
- A real risk assessment specific to your application and deployment.
- Legal review appropriate to your jurisdiction.

---

## Contributing

We welcome contributions from the healthcare security and developer communities! Open issues and PRs to:
- Add more clinical AI pattern architectures.
- Improve compliance checks and automated security validations.

---

## License

MIT - See [LICENSE](LICENSE) for details.
