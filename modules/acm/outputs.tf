output "certificate_arn" {
  description = "ACM certificate ARN"
  value       = aws_acm_certificate_validation.main.certificate_arn
}

output "certificate_domain_name" {
  description = "Certificate primary domain"
  value       = aws_acm_certificate.main.domain_name
}