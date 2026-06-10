data "aws_caller_identity" "current" {}

# Execution role — assumed by the ECS agent to pull images from ECR,
# read SSM parameters, and ship logs to CloudWatch.
resource "aws_iam_role" "ecs_execution" {
  name = "unicycling-rulebook-${var.environment}-ecs-execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_managed" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_execution_ssm" {
  name = "ssm-read"
  role = aws_iam_role.ecs_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["ssm:GetParameters", "ssm:GetParameter"]
      Resource = "arn:aws:ssm:us-west-2:${data.aws_caller_identity.current.account_id}:parameter/unicycling-rulebook/${var.environment}/*"
    }]
  })
}

# Task role — assumed by the application container itself for AWS API calls
# (S3, SES, etc.). Currently the app uses static credentials via env vars;
# permissions can be added here as those are migrated to IAM-based access.
resource "aws_iam_role" "ecs_task" {
  name = "unicycling-rulebook-${var.environment}-ecs-task"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}
