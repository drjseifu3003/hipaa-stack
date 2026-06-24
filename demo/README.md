# HIPAA Stack - Demo & Video Guide

This directory contains a pre-configured, self-contained demo that integrates the three core security foundations of the `hipaa-stack`:
1. **Cryptographic Control (KMS)** — Establishes a Customer Managed Key (CMK) with enforced annual key rotation.
2. **Network Isolation (VPC)** — Builds isolated private subnets, secure VPC Interface Endpoints (PrivateLink), and encrypted VPC Flow Logs.
3. **Immutable/Secure Storage (S3)** — Provisions a server-side encrypted S3 bucket that enforces TLS-only requests and blocks all public access.

---

## 🎥 Recording Your LinkedIn Demo (Suggested Script)

Here is a step-by-step guide to recording a highly engaging terminal walk-through for LinkedIn:

### Step 1: Preparation
Ensure you have AWS credentials exported in your terminal environment. If you want to run `terraform plan` without actual AWS access, you can run it against a mock environment or ensure your AWS CLI is authenticated.

### Step 2: Initialize the Stack
Start your recording with the directory contents showing, then run:
```bash
terraform init
```
* **What to highlight in your voiceover/post:** Note how Terraform smoothly resolves the local modular paths (`../services/kms`, `../services/vpc`, `../services/s3`), showing how easy it is to drop these pre-hardened compliance building blocks into any infrastructure.

### Step 3: Run the Plan
Generate the speculative execution plan:
```bash
terraform plan
```

### Step 4: Key Highlights to Point Out in the Plan Output
Scroll through the plan and call out these secure-by-default compliance features:
1. **Mandatory Key Rotation (`aws_kms_key.key`):**
   * Highlight `enable_key_rotation = true`. This directly satisfies HIPAA §164.312(a)(2)(iv) without manual configuration.
2. **Zero Public Ingress (`aws_subnet.private`):**
   * Point out that only private subnets and secure VPC endpoints are created—no public IPs or open internet gateways are attached to compute resources.
3. **Encrypted Flow Logging (`aws_flow_log.vpc`):**
   * Show that network traffic logs are automatically captured and encrypted with the KMS CMK we just created.
4. **TLS Enforcement & Block Public Access (`aws_s3_bucket_policy.phi_policy`):**
   * Point out the bucket policy denying any non-HTTPS requests (`SecureTransport = false`) and the explicit public access block.
