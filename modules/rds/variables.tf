variable "name_prefix" {
  description = "Prefix used for naming RDS resources"
  type        = string
}

variable "private_db_subnet_ids" {
  description = "Private database subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for RDS"
  type        = string
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "17"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Initial storage size in GB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum storage size in GB"
  type        = number
  default     = 50
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "db_username" {
  description = "Master database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master database password"
  type        = string
  sensitive   = true
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Daily backup window"
  type        = string
  default     = "18:00-18:30"
}

variable "maintenance_window" {
  description = "Weekly maintenance window"
  type        = string
  default     = "sun:19:00-sun:19:30"
}

variable "deletion_protection" {
  description = "Protect RDS from accidental deletion"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when destroying the DB"
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Common tags applied to RDS resources"
  type        = map(string)
  default     = {}
}