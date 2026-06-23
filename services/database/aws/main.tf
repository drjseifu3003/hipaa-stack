# HIPAA-Compliant RDS PostgreSQL Database for AWS
# Aligns with HIPAA Safeguards: 164.312(a)(2)(iv) Encryption/Decryption, 164.308(a)(7)(ii)(A) Data Backup Plan

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# --- Database Subnet Group ---
resource "aws_db_subnet_group" "db" {
  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.name_prefix}-db-subnet-group"
    Environment = var.environment
  }
}

# --- KMS CMK for Database Storage Encryption ---
resource "aws_kms_key" "db" {
  description             = "KMS Key for RDS encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Name        = "${var.name_prefix}-db-key"
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}

# --- RDS PostgreSQL Instance ---
# Aligns with HIPAA Safeguards 164.312(a)(2)(iv) (Storage Encryption) & 164.308(a)(7)(ii)(A) (Backups)
resource "aws_db_instance" "postgres" {
  identifier                = "${var.name_prefix}-db"
  allocated_storage         = var.allocated_storage
  max_allocated_storage     = var.max_allocated_storage
  engine                    = "postgres"
  engine_version            = var.engine_version
  instance_class            = var.instance_class
  db_name                   = var.database_name
  username                  = var.admin_username
  password                  = var.admin_password
  db_subnet_group_name      = aws_db_subnet_group.db.name
  vpc_security_group_ids    = [aws_security_group.db_sg.id]
  multi_az                  = var.multi_az
  publicly_accessible       = false # Enforce private deployment
  storage_encrypted         = true
  kms_key_id                = aws_kms_key.db.arn
  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.name_prefix}-db-final-snapshot"

  # Auditing & Telemetry
  iam_database_authentication_enabled = true
  performance_insights_enabled        = true
  performance_insights_kms_key_id     = aws_kms_key.db.arn
  enabled_cloudwatch_logs_exports     = ["postgresql", "upgrade"]

  # Backups
  backup_retention_period = var.backup_retention_days
  backup_window           = "03:00-04:00"
  maintenance_window      = "Sun:04:30-Sun:05:30"

  tags = {
    Name        = "${var.name_prefix}-db"
    Environment = var.environment
    Compliance  = "HIPAA"
  }
}

# --- Database Security Group ---
resource "aws_security_group" "db_sg" {
  name        = "${var.name_prefix}-db-sg"
  description = "Access control for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow PostgreSQL access from private subnets"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name_prefix}-db-sg"
    Environment = var.environment
  }
}
