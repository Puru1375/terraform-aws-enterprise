variable "name_prefix" {
  description = "Prefix used for ECS resource names"
  type        = string
}

variable "container_name" {
  description = "Name of the application container"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the application container"
  type        = number
  default     = 3000
}

variable "cpu" {
  description = "CPU units allocated to the ECS task"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory in MiB allocated to the ECS task"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 1
}

variable "image_uri" {
  description = "Container image URI"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private application subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups attached to ECS tasks"
  type        = list(string)
}

variable "execution_role_arn" {
  description = "ECS task execution role ARN"
  type        = string
}

variable "task_role_arn" {
  description = "ECS task role ARN"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}