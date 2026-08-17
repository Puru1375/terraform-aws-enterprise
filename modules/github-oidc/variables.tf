variable "github_repository" {
  description = "GitHub repository in OWNER/REPOSITORY format"
  type        = string
}

variable "role_name" {
  description = "IAM role name for GitHub Actions"
  type        = string
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}

variable "github_owner_id" {
  description = "GitHub owner ID"
  type        = string
}

variable "github_repository_id" {
  description = "GitHub repository ID"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch allowed to assume the IAM role"
  type        = string
}