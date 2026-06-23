# AWS ECS Fargate Compute Service

This service provisions an Amazon ECS Cluster running containerized application tasks via AWS Fargate. It aligns with **164.312(a)(1) Access Control** and **164.312(b) Audit Controls**.

## HIPAA Compliance Features
- **Container Isolation**: Tasks run on dedicated serverless infrastructure in private VPC subnets. Public IPs are disabled.
- **Access Control & Permissions**: Utilizes granular task and execution IAM roles to manage resource authorization (least privilege).
- **Container Insights & Logging**: Enables ECS Container Insights for monitoring. Container stdout/stderr logs are encrypted and routed to CloudWatch Logs with customized retention.

## Usage Example

```hcl
module "fargate" {
  source = "github.com/momentum-ai/hipaa-stack//services/fargate"

  name_prefix        = "health"
  environment        = "production"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  allowed_cidr_blocks= ["10.0.0.0/16"]
  kms_key_arn        = module.kms.kms_key_arn

  container_image    = "my-registry/my-clinical-app:latest"
  container_port     = 8080
  desired_count      = 2
}
```
