data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Federated"

      identifiers = [
        "arn:aws:iam::984285320293:oidc-provider/token.actions.githubusercontent.com"
      ]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:${var.github_repository}:ref:refs/heads/${var.github_branch}"
      ]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name = "${var.name_prefix}-app-github-actions-role"

  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-app-github-actions-role"
    }
  )
}

resource "aws_iam_policy" "application_deployment" {
  name = "${var.name_prefix}-app-deployment-policy"

  description = "Permissions for application CI/CD deployment"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [

      # ECR
      {
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]

        Resource = "arn:aws:ecr:ap-south-1:984285320293:repository/${var.name_prefix}-backend"
      },

      # ECS
      {
        Effect = "Allow"

        Action = [
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "ecs:UpdateService"
        ]

        Resource = "*"
      },

      # IAM pass role
      {
        Effect = "Allow"

        Action = [
          "iam:PassRole"
        ]

        Resource = [
          "arn:aws:iam::984285320293:role/${var.name_prefix}-ecs-task-execution-role",
          "arn:aws:iam::984285320293:role/${var.name_prefix}-ecs-task-role"
        ]
      },

      # S3 frontend
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = "arn:aws:s3:::${var.name_prefix}-frontend"
      },

      {
        Effect = "Allow"

        Action = [
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = "arn:aws:s3:::${var.name_prefix}-frontend/*"
      },

      # CloudFront
      {
        Effect = "Allow"

        Action = [
          "cloudfront:CreateInvalidation"
        ]

        Resource = "*"
      }
    ]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "application_deployment" {
  role = aws_iam_role.github_actions.name

  policy_arn = aws_iam_policy.application_deployment.arn
}