# AWS WAFv2 Web Application Firewall Service

This service provisions an AWS WAFv2 Web Access Control List (Web ACL) configured to protect Application Load Balancers or CloudFront distributions from web-based exploits. It aligns with **164.312(a)(1) Access Control** and **164.312(e)(1) Transmission Security**.

## HIPAA Compliance Features
- **SQLi Protection**: Configures managed rules specifically targeting SQL injection attempts on clinical API endpoints.
- **Vulnerability Mitigation**: Blocks common OWASP Top 10 vulnerabilities (using the AWS Managed Rules Common Rule Set) before traffic reaches application compute resources.
- **Telemetry logging**: Captures metric details for WAF blocks and routes them to CloudWatch Metrics for automated alerting.

## Usage Example

```hcl
module "waf" {
  source = "github.com/drjseifu3003/hipaa-stack//services/waf"

  name_prefix = "health-prod"
  environment = "production"
  scope       = "REGIONAL"
}
```
