variable "name_prefix" {
  description = "Prefix for IAM role names"
  type        = string
}

variable "common_tags" {
  description = "Common IAM resource tags"
  type        = map(string)
  default     = {}
}