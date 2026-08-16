variable "name_prefix" {
  description = "Prefix for IAM role names"
  type        = string
}

variable "common_tags" {
  description = "Common IAM resource tags"
  type        = map(string)
  default     = {}
}

variable "database_secret_arn" {
  description = "ARN of the database credentials secret"
  type        = string
}