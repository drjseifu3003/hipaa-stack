# HIPAAStack

**Multi-cloud, compliance-first infrastructure for healthcare AI systems.**

HIPAAStack provides battle-tested infrastructure modules organized around
*compliance problems* — not cloud service names — so the same module set
works whether you're deploying on AWS, Azure, or GCP. Each module is built
to satisfy specific HIPAA / PIPA / PIPEDA technical safeguards, with the
reasoning documented inline, not just the configuration.

Built from real client work: AI voice triage systems, EMR integrations with
no public API, multi-tenant clinical platforms, and AI agent systems
handling PHI directly.

## Why problem-first, not service-first

Most infrastructure-as-code libraries for healthcare are organized by cloud
service name — "here's our S3 module, here's our KMS module." That's useful
if you already know AWS maps "encrypted storage" to S3+KMS. It's a dead end
if you're on Azure or GCP, or if you're a developer who doesn't have an AWS
background and just knows you need "a place to store files that's
encrypted and HIPAA-safe."

HIPAAStack is organized the other way: pick the **problem** you're solving
— encrypted storage, network isolation, audit logging, AI agent guardrails
— and get the implementation for whichever cloud you're actually on.

## Module status

| Problem | AWS | Azure | GCP |
|---|---|---|---|
| Network Isolation | ✅ Available | 🔜 Coming Soon | 🔜 Coming Soon |
| Encrypted Storage | 🔜 Coming Soon | 🔜 Coming Soon | 🔜 Coming Soon |
| Secrets Management | 🔜 Coming Soon | 🔜 Coming Soon | 🔜 Coming Soon |
| Audit Logging | 🔜 Coming Soon | 🔜 Coming Soon | 🔜 Coming Soon |
| Identity & Access | 🔜 Coming Soon | 🔜 Coming Soon | 🔜 Coming Soon |
| AI Agent Guardrails | 🔜 Coming Soon | 🔜 Coming Soon | 🔜 Coming Soon |

AWS modules are being built and validated first. Azure and GCP equivalents
will follow the same problem-first structure once each AWS module is
production-tested.

## Beyond infrastructure — the application layer

Infrastructure is necessary but not sufficient. A perfectly encrypted VPC
doesn't stop a developer from pasting a patient's name into an AI prompt.
The `patterns/` and `skill/` directories cover the application-layer
problems infrastructure-as-code can't solve on its own:

- **`patterns/emr-without-public-api.md`** — how to integrate with EMRs
  that don't expose a developer API (more common than you'd think — most
  IaC libraries assume FHIR/API access exists)
- **`patterns/deterministic-triage-scoring.md`** — keeping AI out of
  clinical judgment calls while still using it for conversation and data
  collection
- **`patterns/phi-tokenization-for-llm-prompts.md`** — preventing PHI from
  ever reaching an LLM prompt or API call in the first place
- **`patterns/voice-ai-phi-handling.md`** — specific guidance for Vapi/
  Twilio-style voice AI systems that handle PHI in real time
- **`skill/SKILL.md`** — a Claude/Cursor-compatible skill file enforcing
  these patterns automatically during development

## Quick start

```hcl
module "network" {
  source = "github.com/yourname/hipaastack//modules/network-isolation/aws"

  name_prefix = "clinic-prod"
  environment = "production"
  aws_region  = "ca-central-1"
}
```

See each module's own README for full usage and a working example.

## What this is not

This repo does not make your application "HIPAA compliant" by itself. No
infrastructure code can. You still need:

- Signed Business Associate Agreements (BAAs) with every subprocessor
- Organizational policy, staff training, and breach notification procedures
- A real risk assessment specific to your application
- Legal review appropriate to your jurisdiction

What this repo does: give you a tested, documented starting point for the
technical safeguards, so you're not researching "what's the right KMS key
policy for PHI" from scratch on every project.

## Compliance mapping

See [`docs/compliance-mapping.md`](./docs/compliance-mapping.md) for a full
breakdown of which HIPAA Technical Safeguard (and equivalent PIPA/PIPEDA
provisions) each module addresses.

## Contributing

This project is in active early development. Issues and PRs welcome,
especially:

- Azure and GCP implementations of existing AWS modules
- Real-world pattern write-ups from your own healthcare AI builds
- Corrections to compliance mapping — if something is wrong, open an issue

## License

MIT
