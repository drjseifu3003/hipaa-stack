# HIPAA Stack Agent Guidelines & Guardrails

This document defines the workspace-scoped rules, coding standards, and compliance guardrails that all AI agents must strictly adhere to when developing, reviewing, or modifying code in the `hipaa-stack` repository.

---

## 1. Core Mandate: HIPAA Security Rule Compliance

The primary objective of the `hipaa-stack` project is to provide secure, production-ready Infrastructure as Code (IaC) blueprints that satisfy HIPAA / HITECH Technical Safeguards (45 CFR § 164.312) on AWS. 

All modifications and new contributions must enforce the following security pillars:

### A. Data Isolation & Network Security (§ 164.312(a)(1))
* **Zero Public Ingress**: All databases, key management infrastructure, and compute workloads (ECS Fargate) must be deployed in private subnets with no direct routing to or from the public internet.
* **Secure Transit Gateways**: Any ingress must route through secure gateways, such as AWS Client VPN or Application Load Balancers protected by AWS WAFv2.
* **Internal Routing**: Utilize AWS PrivateLink (VPC Interface Endpoints) for internal communications between services (e.g., S3, KMS, Secrets Manager) to ensure traffic remains on the AWS network backbone.

### B. Encryption Everywhere (§ 164.312(a)(2)(iv) & § 164.312(e)(1))
* **Encryption at Rest**: All storage resources (S3 buckets, RDS PostgreSQL instances, HealthLake FHIR datastores, Secrets Manager secrets) must use Server-Side Encryption backed by an AWS KMS Customer Managed Key (CMK).
* **Key Rotation**: Enforce automatic annual rotation on all KMS CMKs (`enable_key_rotation = true`).
* **Encryption in Transit**: All data in transit must be encrypted. For S3, apply policies that deny non-HTTPS traffic (`aws:SecureTransport = "false"`). For RDS, enforce SSL/TLS connections (`rds.force_ssl = 1`).

### C. Immutable Auditing & Monitoring (§ 164.312(b))
* **Activity Logging**: Capture both management-plane and data-plane operations (e.g., S3 reads/writes) using AWS CloudTrail.
* **Log Encryption & Retention**: Centralize logs in AWS CloudWatch Log Groups. Encrypt all log groups using the KMS CMK, and set retention policies to at least 365 days to meet clinical audit compliance.
* **VPC Flow Logs**: Enable flow logging across the VPC to monitor internal network traffic.

### D. Data Integrity & Disaster Recovery (§ 164.312(c)(1))
* **S3 Versioning**: Always enable S3 Object Versioning to prevent accidental overrides or deletions of clinical records.
* **Backup Policies**: Integrate automated daily snapshots and backups with custom retention locks using AWS Backup.

---

## 2. Protected Health Information (PHI) Guardrails

Any combination of clinical data (vitals, diagnoses, prescriptions) and patient identifiers constitutes Electronic Protected Health Information (ePHI) and must be protected.

### The 18 HIPAA Identifiers
Never permit the exposure, logging, or hardcoding of the following identifiers:
1. Names
2. Geographic subdivisions smaller than a state (street addresses, ZIP codes)
3. Dates directly related to an individual (birth, admission, discharge, death dates)
4. Telephone numbers
5. Fax numbers
6. Email addresses
7. Social Security Numbers (SSN)
8. Medical Record Numbers (MRN)
9. Health plan beneficiary numbers
10. Account numbers
11. Certificate/license numbers
12. Vehicle identifiers and serial numbers (including license plates)
13. Device identifiers and serial numbers
14. Web Universal Resource Locators (URLs)
15. Internet Protocol (IP) addresses
16. Biometric identifiers (fingerprints, voiceprints)
17. Full-face photographs and comparable images
18. Any other unique identifying number, characteristic, or code

### Implementation Rules
* **No Raw PHI in Logs**: Ensure that application logs, error messages, and telemetry events do not print raw PHI. Implement sanitization or regex-based redactors for standard formats (SSNs, emails, phone numbers).
* **Opaque Identifiers**: Use database-generated UUIDs or secure hashes as target identifiers in audit trails. Never pass patient names or MRNs in audit payload fields.
* **Secure API Paths**: Do not use PHI in API route parameters (e.g., use `/records` with payloads or headers instead of `/patients/{email}/records`).

---

## 3. Terraform Coding Standards

When writing or modifying Infrastructure as Code (IaC) modules:

* **Strict Tagging**: Apply standard metadata tags to all resource blocks:
  ```hcl
  tags = {
    Environment = var.environment
    Compliance  = "HIPAA"
  }
  ```
* **Explicit S3 Security**: Always accompany S3 bucket definitions with `aws_s3_bucket_public_access_block` setting all block options to `true`, and attach an `aws_s3_bucket_policy` enforcing TLS.
* **Least Privilege KMS Policies**: Restrict KMS key policies using conditions (such as `aws:sourceVpc`) to ensure only authorized VPC resources can invoke the key.
* **Explicit Provider Constraints**: Declare required provider versions (e.g., `aws ~> 5.0`) and minimum Terraform versions (e.g., `>= 1.3.0`) in the `terraform` configuration block of each service.

---

## 4. Pull Request & Verification Checklist

Before proposing or completing any changes, verify the following checklist:

- [ ] **No Telemetry Leakage**: Review all log and error statements to verify no clinical text, patient names, or identifiers are printed.
- [ ] **Secure Routing**: Ensure API paths use secure, opaque identifiers rather than PHI parameters.
- [ ] **Transit and Rest Encryption**: Verify new S3 buckets, RDS instances, and other storage media have KMS encryption enabled and SSL/TLS transport enforced.
- [ ] **Auditing Triggers**: Confirm that any action creating, reading, updating, or deleting PHI triggers a corresponding immutable audit event containing the *who, when, and what* (using opaque IDs).
- [ ] **Terraform Linting**: Ensure all configurations are formatted with `terraform fmt` and pass basic syntactic checks.
