data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.name_prefix}-ecs-task-execution-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role = aws_iam_role.ecs_task_execution.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task" {
  name = "${var.name_prefix}-ecs-task-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = var.common_tags
}

resource "aws_iam_policy" "ecs_secrets" {
  name = "${var.name_prefix}-ecs-secrets-policy"

  description = "Allow ECS to retrieve application secrets"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = var.database_secret_arn
      }
    ]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "ecs_secrets" {
  role = aws_iam_role.ecs_task_execution.name

  policy_arn = aws_iam_policy.ecs_secrets.arn
}

