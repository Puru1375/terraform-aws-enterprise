variable "name_prefix" {
  description = "Prefix used for naming network ACL resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the network ACLs will be created"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of public subnets"
  type        = list(string)
}

variable "private_app_subnet_ids" {
  description = "IDs of private application subnets"
  type        = list(string)
}

variable "private_db_subnet_ids" {
  description = "IDs of private database subnets"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
  default     = {}
}
