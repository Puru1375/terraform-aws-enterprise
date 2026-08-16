variable "name_prefix" {
  description = "Prefix used for naming the secret"
  type        = string
}

variable "db_username" {
  description = "RDS database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
}

variable "db_host" {
  description = "RDS database endpoint"
  type        = string
}

variable "db_port" {
  description = "RDS database port"
  type        = number
}

variable "db_name" {
  description = "RDS database name"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
  default     = {}
}