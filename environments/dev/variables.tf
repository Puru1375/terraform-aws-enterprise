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

