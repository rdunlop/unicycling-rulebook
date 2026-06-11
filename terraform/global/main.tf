terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_ecr_repository" "app" {
  name                 = "unicycling-rulebook"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 20 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 20
      }
      action = { type = "expire" }
    }]
  })
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

# ---- CI IAM user (CircleCI) ----

resource "aws_iam_user" "circleci" {
  name = "circleci-unicycling-rulebook"
}

resource "aws_iam_access_key" "circleci" {
  user = aws_iam_user.circleci.name
}

resource "aws_iam_user_policy" "circleci_ecr" {
  name = "ecr-push"
  user = aws_iam_user.circleci.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ECRAuth"
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        Sid    = "ECRPush"
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
        ]
        Resource = aws_ecr_repository.app.arn
      },
    ]
  })
}

resource "aws_iam_user_policy" "circleci_ecs_migrate" {
  name = "ecs-migrate"
  user = aws_iam_user.circleci.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Needed to look up ECS task security groups by name.
        Sid      = "EC2DescribeSGs"
        Effect   = "Allow"
        Action   = "ec2:DescribeSecurityGroups"
        Resource = "*"
      },
      {
        # Launch one-off migration tasks.
        Sid    = "ECSRunTask"
        Effect = "Allow"
        Action = "ecs:RunTask"
        Resource = "arn:aws:ecs:us-west-2:*:task-definition/unicycling-rulebook-*-web"
      },
      {
        # Poll and inspect task status (used by `aws ecs wait tasks-stopped`).
        Sid      = "ECSDescribeTasks"
        Effect   = "Allow"
        Action   = "ecs:DescribeTasks"
        Resource = "*"
      },
      {
        # Required so ECS can assume the execution and task roles on CircleCI's behalf.
        Sid    = "PassECSRoles"
        Effect = "Allow"
        Action = "iam:PassRole"
        Resource = "arn:aws:iam::*:role/unicycling-rulebook-*-ecs-*"
      },
    ]
  })
}

output "circleci_access_key_id" {
  value = aws_iam_access_key.circleci.id
}

output "circleci_secret_access_key" {
  value     = aws_iam_access_key.circleci.secret
  sensitive = true
}
