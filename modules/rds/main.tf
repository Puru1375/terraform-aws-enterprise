resource "aws_db_subnet_group" "main" {
  name = "${var.name_prefix}-db-subnet-group"

  subnet_ids = var.private_db_subnet_ids

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-db-subnet-group"
      Tier = "private-db"
    }
  )
}


resource "aws_db_instance" "main" {
  identifier = "${var.name_prefix}-postgres"

  engine         = "postgres"
  engine_version = var.engine_version

  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 5432

  db_subnet_group_name = aws_db_subnet_group.main.name

  vpc_security_group_ids = [
    var.security_group_id
  ]

  publicly_accessible = false

  multi_az = var.multi_az

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  auto_minor_version_upgrade = true

  deletion_protection = var.deletion_protection

  skip_final_snapshot = var.skip_final_snapshot

  copy_tags_to_snapshot = true

  monitoring_interval = 0

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-postgres"
      Tier = "private-db"
    }
  )
}