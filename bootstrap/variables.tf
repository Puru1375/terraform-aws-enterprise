variable "project_name" {
  description = "Name of the Terraform project"
  type        = string
  default     = "enterprise"
}

variable "environment" {
  description = "Environment for bootstrap resources"
  type        = string
  default     = "global"
}
