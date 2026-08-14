resource "aws_lb" "main" {
  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    var.security_group_id
  ]

  subnets = var.public_subnet_ids

  enable_deletion_protection = false

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-alb"
    }
  )
}

resource "aws_lb_target_group" "app" {
  name = "${var.name_prefix}-tg"

  port     = var.target_port
  protocol = "HTTP"

  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {
    enabled = true

    path = var.health_check_path

    protocol = "HTTP"

    port = "traffic-port"

    healthy_threshold   = 2
    unhealthy_threshold = 3

    timeout  = 5
    interval = 30

    matcher = "200"
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-target-group"
    }
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn = aws_lb_target_group.app.arn
      }
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-http-listener"
    }
  )
}



