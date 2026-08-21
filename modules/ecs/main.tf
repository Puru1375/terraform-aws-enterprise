resource "aws_ecs_cluster" "main" {
  name = "${var.name_prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-cluster"
    }
  )
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.name_prefix}/app"
  retention_in_days = 7

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-app-logs"
    }
  )
}

resource "aws_ecs_task_definition" "app" {
  family = "${var.name_prefix}-task"

  network_mode = "awsvpc"

  requires_compatibilities = [
    "FARGATE"
  ]

  cpu    = tostring(var.cpu)
  memory = tostring(var.memory)

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.image_uri
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      secrets = var.container_secrets

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.app.name
          awslogs-region        = "ap-south-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-task-definition"
    }
  )

  lifecycle {
    ignore_changes = [
      container_definitions
    ]
  }
}

resource "aws_ecs_service" "app" {
  name = "${var.name_prefix}-service"

  cluster = aws_ecs_cluster.main.id

  task_definition = aws_ecs_task_definition.app.arn

  desired_count = var.desired_count

  launch_type = "FARGATE"

  network_configuration {
    subnets = var.private_subnet_ids

    security_groups = var.security_group_ids

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn

    container_name = var.container_name

    container_port = var.container_port
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-service"
    }
  )

  lifecycle {
  ignore_changes = [
    desired_count,
    task_definition
  ]
}

}