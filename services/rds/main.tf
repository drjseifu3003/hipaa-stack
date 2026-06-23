# HIPAA-Compliant Amazon RDS Service
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

resource "aws_db_subnet_group" "db" {
  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.name_prefix}-db-subnet-group"
    Environment = var.environment
  }
}

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
  publicly_accessible       = false
  storage_encrypted         = true
  kms_key_id                = var.kms_key_arn
  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.name_prefix}-db-final-snapshot"

  # Audit and Logs
  iam_database_authentication_enabled = true
  performance_insights_enabled        = true
  performance_insights_kms_key_id     = var.kms_key_arn
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

resource "aws_security_group" "db_sg" {
  name        = "${var.name_prefix}-db-sg"
  description = "Access control for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow PostgreSQL access from authorized subnet ranges"
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
