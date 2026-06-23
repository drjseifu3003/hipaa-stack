# AWS GuardDuty Threat Detection Service

This service configures AWS GuardDuty to perform continuous security threat scanning across your AWS accounts, aligned with **164.312(b) Audit Controls**.

## HIPAA Compliance Features
- **Intrusion Detection**: Scans VPC Flow Logs, DNS logs, and CloudTrail management events to locate brute force access, compromised keys, or port scans.
- **Malware Scanning**: Evaluates API requests and resource access flows against known bad signatures.
- **Fast Notification Intervals**: Publishes findings to Security Hub or custom SNS topics in 15-minute intervals.

## Usage Example

```hcl
module "guardduty" {
  source = "github.com/momentum-ai/hipaa-stack//services/guardduty"

  environment                  = "production"
  enable_detector              = true
  finding_publishing_frequency = "FIFTEEN_MINUTES"
}
```
