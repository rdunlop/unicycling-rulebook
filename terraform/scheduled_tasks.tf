# Replaces the whenever/cron setup that ran on EC2.
# EventBridge triggers a one-off ECS task on a schedule; the task exits when done.
# Logs go to the web CloudWatch log group alongside normal web container logs.

# IAM role that EventBridge assumes to launch ECS tasks.
resource "aws_iam_role" "eventbridge_ecs" {
  name = "unicycling-rulebook-${var.environment}-eventbridge-ecs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "events.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "eventbridge_ecs" {
  name = "run-ecs-task"
  role = aws_iam_role.eventbridge_ecs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ecs:RunTask"
        Resource = "arn:aws:ecs:us-west-2:${data.aws_caller_identity.current.account_id}:task-definition/${aws_ecs_task_definition.web.family}:*"
        Condition = {
          ArnLike = { "ecs:cluster" = aws_ecs_cluster.app.arn }
        }
      },
      {
        # Required so EventBridge can hand the execution and task roles to ECS.
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = [
          aws_iam_role.ecs_execution.arn,
          aws_iam_role.ecs_task.arn,
        ]
      },
    ]
  })
}

# ---- rake update_proposal_states ----
# Mirrors: every 1.day, at: '12am' in config/schedule.rb
# Runs at midnight UTC. Adjust if a different timezone is needed.

resource "aws_cloudwatch_event_rule" "update_proposal_states" {
  name                = "unicycling-rulebook-${var.environment}-update-proposal-states"
  description         = "Daily rake update_proposal_states (replaces whenever cron)"
  schedule_expression = "cron(0 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "update_proposal_states" {
  rule     = aws_cloudwatch_event_rule.update_proposal_states.name
  arn      = aws_ecs_cluster.app.arn
  role_arn = aws_iam_role.eventbridge_ecs.arn

  ecs_target {
    # Reference the family ARN (no revision number) so EventBridge always
    # picks up the latest active task definition after each deployment.
    task_definition_arn = "arn:aws:ecs:us-west-2:${data.aws_caller_identity.current.account_id}:task-definition/${aws_ecs_task_definition.web.family}"
    task_count          = 1
    launch_type         = "FARGATE"

    network_configuration {
      subnets          = var.subnet_ids
      security_groups  = [aws_security_group.ecs_tasks.id]
      assign_public_ip = true
    }
  }

  input = jsonencode({
    containerOverrides = [{
      name    = "web"
      command = ["bundle", "exec", "rake", "update_proposal_states"]
    }]
  })
}
