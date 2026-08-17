data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "../../modules/vpc"

  name_prefix = local.name_prefix
  vpc_cidr    = var.vpc_cidr

  availability_zones = slice(
    data.aws_availability_zones.available.names,
    0,
    3
  )

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]

  private_app_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24",
    "10.0.13.0/24"
  ]

  private_db_subnet_cidrs = [
    "10.0.21.0/24",
    "10.0.22.0/24",
    "10.0.23.0/24"
  ]

  enable_nat_gateway = true
  single_nat_gateway = true

  common_tags = local.common_tags
}

module "security_groups" {
  source = "../../modules/security-groups"

  name_prefix = local.name_prefix
  vpc_id      = module.vpc.vpc_id
  app_port    = 3000

  common_tags = local.common_tags
}

module "network_acls" {
  source = "../../modules/network-acls"

  name_prefix = local.name_prefix
  vpc_id      = module.vpc.vpc_id
  vpc_cidr    = var.vpc_cidr

  public_subnet_ids = module.vpc.public_subnet_ids

  private_app_subnet_ids = module.vpc.private_app_subnet_ids

  private_db_subnet_ids = module.vpc.private_db_subnet_ids

  common_tags = local.common_tags
}

module "iam" {
  source = "../../modules/iam"

  database_secret_arn = module.secrets_manager.database_secret_arn
  name_prefix         = local.name_prefix
  common_tags         = local.common_tags
}

module "ecr" {
  source = "../../modules/ecr"

  name_prefix     = local.name_prefix
  repository_name = "${local.name_prefix}-backend"

  common_tags = local.common_tags
}

module "alb" {
  source = "../../modules/alb"

  name_prefix = local.name_prefix

  vpc_id = module.vpc.vpc_id

  public_subnet_ids = module.vpc.public_subnet_ids

  security_group_id = module.security_groups.alb_security_group_id

  target_port = 3000

  health_check_path = "/health"

  common_tags = local.common_tags
}

module "ecs" {
  source = "../../modules/ecs"

  name_prefix = local.name_prefix

  container_name = "backend"

  container_port = 3000

  cpu    = 256
  memory = 512

  desired_count = 1

  image_uri = "${module.ecr.repository_url}:latest"

  private_subnet_ids = module.vpc.private_app_subnet_ids

  security_group_ids = [
    module.security_groups.ecs_security_group_id
  ]

  execution_role_arn = module.iam.ecs_task_execution_role_arn

  task_role_arn = module.iam.ecs_task_role_arn

  target_group_arn = module.alb.target_group_arn

  container_secrets = [
    {
      name      = "DATABASE_URL"
      valueFrom = "${module.secrets_manager.database_secret_arn}:DATABASE_URL::"
    }
  ]

  common_tags = local.common_tags
}

module "rds" {
  source = "../../modules/rds"

  name_prefix = local.name_prefix

  private_db_subnet_ids = module.vpc.private_db_subnet_ids

  security_group_id = module.security_groups.rds_security_group_id

  engine_version = var.rds_engine_version

  instance_class = var.rds_instance_class

  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  multi_az = var.rds_multi_az

  backup_retention_period = var.rds_backup_retention_period

  deletion_protection = var.rds_deletion_protection

  skip_final_snapshot = var.rds_skip_final_snapshot

  common_tags = local.common_tags
}

module "secrets_manager" {
  source = "../../modules/secrets-manager"

  name_prefix = local.name_prefix

  db_username = var.db_username
  db_password = var.db_password

  db_host = module.rds.db_endpoint
  db_port = module.rds.db_port
  db_name = module.rds.db_name

  common_tags = local.common_tags
}

module "frontend" {
  source = "../../modules/frontend"

  name_prefix = local.name_prefix

  alb_dns_name = module.alb.alb_dns_name

  common_tags = local.common_tags
}

module "github_oidc" {
  source = "../../modules/github-oidc"

  github_repository = "Puru1375/terraform-aws-enterprise"

  role_name = "${local.name_prefix}-github-actions-role"

  common_tags = local.common_tags
}



