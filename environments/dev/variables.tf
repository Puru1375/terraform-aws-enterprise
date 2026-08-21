variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string

  validation {
    condition     = var.aws_region == "ap-south-1"
    error_message = "This project currently uses ap-south-1."
  }
}

variable "project_name" {
  description = "Name of the project"
  type        = string

  validation {
    condition     = length(var.project_name) >= 3
    error_message = "Project name must contain at least 3 characters."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 0
}

variable "rds_engine_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "17"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "rds_allocated_storage" {
  description = "Initial RDS storage in GB"
  type        = number
  default     = 20
}

variable "rds_max_allocated_storage" {
  description = "Maximum RDS storage in GB"
  type        = number
  default     = 50
}

variable "db_name" {
  description = "Application database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "rds_multi_az" {
  description = "Enable RDS Multi-AZ"
  type        = bool
  default     = false
}

variable "rds_backup_retention_period" {
  description = "RDS automated backup retention in days"
  type        = number
  default     = 0
}

variable "rds_deletion_protection" {
  description = "Enable RDS deletion protection"
  type        = bool
  default     = false
}

variable "rds_skip_final_snapshot" {
  description = "Skip final snapshot when RDS is destroyed"
  type        = bool
  default     = true
}
