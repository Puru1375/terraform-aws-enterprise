resource "aws_secretsmanager_secret" "database" {
  name = "${var.name_prefix}/database"

  description = "Database credentials for ${var.name_prefix}"

  recovery_window_in_days = 0

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-database-secret"
      Tier = "application"
    }
  )
}

resource "aws_secretsmanager_secret_version" "database" {
  secret_id = aws_secretsmanager_secret.database.id

  secret_string = jsonencode({
  DATABASE_URL = "postgresql://${var.db_username}:${var.db_password}@${var.db_host}:${var.db_port}/${var.db_name}"
})

}