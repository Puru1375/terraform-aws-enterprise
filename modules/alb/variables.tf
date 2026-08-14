variable "name_prefix" {
  description = "Prefix used for ALB resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs where the ALB will be deployed"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group attached to the ALB"
  type        = string
}

variable "target_port" {
  description = "Port used by the ECS application"
  type        = number
  default     = 3000
}

variable "health_check_path" {
  description = "Application health check path"
  type        = string
  default     = "/health"
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
