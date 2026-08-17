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