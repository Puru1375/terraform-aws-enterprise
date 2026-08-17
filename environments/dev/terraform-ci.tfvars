aws_region   = "ap-south-1"
project_name = "enterprise"
environment  = "dev"

vpc_cidr = "10.0.0.0/16"

rds_engine_version = "17"

rds_instance_class = "db.t4g.micro"

rds_allocated_storage     = 20
rds_max_allocated_storage = 50

db_name     = "enterprise"
db_username = "enterprise_admin"

rds_multi_az = false

rds_backup_retention_period = 0

rds_deletion_protection = false

rds_skip_final_snapshot = true