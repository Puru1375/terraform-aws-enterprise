variable "name_prefix" {
  description = "Prefix used for frontend resources"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to frontend resources"
  type        = map(string)
  default     = {}
}

variable "alb_dns_name" {
  description = "DNS name of the ALB"
  type        = string
}