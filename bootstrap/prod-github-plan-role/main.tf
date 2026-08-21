terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "enterprise-terraform-state-984285320293"
    key          = "bootstrap/prod-github-plan-role/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-south-1"
}

#
# Existing GitHub OIDC provider
#

data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

#
# Trust policy
#

data "aws_iam_policy_document" "github_plan_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        data.aws_iam_openid_connect_provider.github.arn
      ]
    }

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
        "repo:Puru1375@138357143/terraform-aws-enterprise@1332203849:pull_request"
      ]
    }
  }
}

#
# Production Terraform PLAN role
#

resource "aws_iam_role" "github_plan" {
  name = "enterprise-prod-github-plan-role"

  assume_role_policy = data.aws_iam_policy_document.github_plan_assume_role.json

  tags = {
    Name        = "enterprise-prod-github-plan-role"
    Project     = "enterprise"
    Environment = "prod"
    ManagedBy   = "Terraform"
    Owner       = "DevOps"
  }
}

#
# Read-only access for Terraform refresh/plan
#

resource "aws_iam_role_policy_attachment" "readonly" {
  role = aws_iam_role.github_plan.name

  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

#
# Terraform remote state access
#

data "aws_iam_policy_document" "terraform_state" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::enterprise-terraform-state-984285320293"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::enterprise-terraform-state-984285320293/*"
    ]
  }
}

resource "aws_iam_role_policy" "terraform_state" {
  name = "terraform-state-access"

  role = aws_iam_role.github_plan.name

  policy = data.aws_iam_policy_document.terraform_state.json
}

output "role_arn" {
  value = aws_iam_role.github_plan.arn
}

output "role_name" {
  value = aws_iam_role.github_plan.name
}