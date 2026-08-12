variable "name_prefix" {
  description = "Prefix for security group names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "app_port" {
  description = "Application port exposed by ECS"
  type        = number
  default     = 3000
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}