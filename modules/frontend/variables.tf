variable "name_prefix" {
  description = "Prefix used for frontend resources"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to frontend resources"
  type        = map(string)
  default     = {}
}