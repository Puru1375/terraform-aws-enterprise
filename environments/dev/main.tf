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

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}

module "ecr" {
  source = "../../modules/ecr"

  name_prefix     = local.name_prefix
  repository_name = "${local.name_prefix}-backend"

  common_tags = local.common_tags
}