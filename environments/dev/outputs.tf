output "project_name" {
  description = "Project name"
  value       = var.project_name
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}

output "aws_region" {
  description = "AWS deployment region"
  value       = var.aws_region
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Private application subnet IDs"
  value       = module.vpc.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Private database subnet IDs"
  value       = module.vpc.private_db_subnet_ids
}

output "alb_security_group_id" {
  value = module.security_groups.alb_security_group_id
}

output "ecs_security_group_id" {
  value = module.security_groups.ecs_security_group_id
}

output "rds_security_group_id" {
  value = module.security_groups.rds_security_group_id
}

output "public_nacl_id" {
  value = module.network_acls.public_nacl_id
}

output "private_app_nacl_id" {
  value = module.network_acls.private_app_nacl_id
}

output "private_db_nacl_id" {
  value = module.network_acls.private_db_nacl_id
}

output "ecs_task_execution_role_arn" {
  value = module.iam.ecs_task_execution_role_arn
}

output "ecs_task_role_arn" {
  value = module.iam.ecs_task_role_arn
}

output "ecr_repository_name" {
  description = "ECR backend repository name"
  value       = module.ecr.repository_name
}

output "ecr_repository_url" {
  description = "ECR backend repository URL"
  value       = module.ecr.repository_url
}

output "ecs_cluster_id" {
  description = "ECS cluster ID"
  value       = module.ecs.cluster_id
}

output "ecs_cluster_arn" {
  description = "ECS cluster ARN"
  value       = module.ecs.cluster_arn
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = module.ecs.service_name
}

output "ecs_task_definition_arn" {
  description = "ECS task definition ARN"
  value       = module.ecs.task_definition_arn
}

output "ecs_log_group_name" {
  description = "ECS CloudWatch log group"
  value       = module.ecs.log_group_name
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ALB ARN"
  value       = module.alb.alb_arn
}

output "alb_target_group_arn" {
  description = "ALB target group ARN"
  value       = module.alb.target_group_arn
}

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = module.rds.db_endpoint
}

output "rds_port" {
  description = "RDS PostgreSQL port"
  value       = module.rds.db_port
}

output "rds_instance_id" {
  description = "RDS instance ID"
  value       = module.rds.db_instance_id
}

output "rds_database_name" {
  description = "Application database name"
  value       = module.rds.db_name
}

output "database_secret_arn" {
  description = "ARN of the database credentials secret"
  value       = module.secrets_manager.database_secret_arn
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.frontend.cloudfront_domain_name
}