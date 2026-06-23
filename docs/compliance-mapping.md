# HIPAA Compliance Mapping (AWS)

This document provides a detailed mapping of the **HIPAA Security Rule Technical Safeguards (45 CFR § 164.312)** to the AWS Terraform services provided in this repository.

## Compliance Safeguards Matrix

| HIPAA Safeguard | Requirement Summary | AWS Service & Resource Mapping |
| :--- | :--- | :--- |
| **§ 164.312(a)(1)**<br>Access Control | Establish policies and procedures to limit access to authorized users/systems. | - `network-isolation/aws` (VPC Private Subnets, Security Groups, Client VPN)<br>- `secrets-management/aws` (KMS Key Policies restricting decryption)<br>- `compute/aws` (ECS Task IAM roles enforcing least-privilege) |
| **§ 164.312(a)(2)(iv)**<br>Encryption & Decryption | Encrypt and decrypt Electronic Protected Health Information (ePHI) where appropriate. | - `encrypted-storage/aws` (S3 SSE-KMS Customer Managed Key encryption)<br>- `database/aws` (RDS PostgreSQL storage encryption with KMS CMK)<br>- `healthcare-store/aws` (HealthLake FHIR Datastore KMS KMS encryption) |
| **§ 164.312(b)**<br>Audit Controls | Record and examine activity in systems containing or utilizing ePHI. | - `audit-logging/aws` (CloudTrail Trail logging API management and S3 data-plane events)<br>- `network-isolation/aws` (VPC Flow Logs stream to CloudWatch Logs)<br>- `compute/aws` (ECS Container logs sent to KMS-encrypted CloudWatch Log Group) |
| **§ 164.312(c)(1)**<br>Integrity | Protect ePHI from improper alteration or destruction. | - `encrypted-storage/aws` (S3 Object Versioning enabled to track mutation history)<br>- `database/aws` (Automated RDS database snapshots with a 30-day retention period) |
| **§ 164.312(d)**<br>Authentication | Verify that a person or entity seeking access to ePHI is the one claimed. | - `secrets-management/aws` (IAM DB Authentication for RDS, Secrets Manager token credentials) |
| **§ 164.312(e)(1)**<br>Transmission Security | Guard against unauthorized access to ePHI being transmitted. | - `encrypted-storage/aws` (S3 Bucket Policy denying insecure `aws:SecureTransport = false` transport)<br>- `network-isolation/aws` (VPC PrivateLink Interface Endpoints for S3, KMS, Secrets Manager, and Bedrock preventing routing over the public internet) |
| **§ 164.308(a)(7)(ii)(A)**<br>Data Backup Plan | Establish and implement procedures to create and maintain retrievable exact copies of ePHI. | - `encrypted-storage/aws` (AWS Backup Vault and daily backup plans for S3 buckets)<br>- `database/aws` (RDS PostgreSQL automated backup window and retention) |

---

## AWS Technical Safeguard Details

### 1. Transmission Security & Private Routing
Under § 164.312(e)(1), any connection carrying PHI must be encrypted.
- **S3 Bucket Policies**: Explicitly deny any non-SSL/TLS (HTTP) requests by denying any action when `aws:SecureTransport = "false"`.
- **VPC Interface Endpoints (AWS PrivateLink)**: Establish secure connections to Amazon S3, KMS, Secrets Manager, and Bedrock. Application instances in private subnets make API calls directly over private IP networks, ensuring that database connections and LLM inference calls never traverse the public internet.

### 2. Encryption at Rest
Under § 164.312(a)(2)(iv), PHI must be encrypted at rest using industry-standard algorithms (AES-256).
- **Customer Managed Keys (CMKs)**: All services enforce Customer Managed Keys created in AWS KMS, with automatic annual key rotation enabled.
- **Service Integrations**: Storage buckets, database volumes, Secrets Manager payloads, and HealthLake datastores must reference a specific CMK ARN, rather than the default AWS-managed service keys.

### 3. Audit Logging & Non-Repudiation
Under § 164.312(b), systems must log all read, write, and access attempts.
- **CloudTrail logging**: Configured as a multi-region trail with Log File Validation enabled. Log file validation writes digital signatures to log headers, making any malicious log deletions or alterations mathematically detectable.
- **VPC Flow Logs**: Capture IP traffic flow details on all network interfaces. Log groups are KMS-encrypted and retained for 365 days.
