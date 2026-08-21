output "role_arn" {
  description = "Application GitHub Actions IAM role ARN"
  value       = aws_iam_role.github_actions.arn
}

output "role_name" {
  description = "Application GitHub Actions IAM role name"
  value       = aws_iam_role.github_actions.name
}