resource "aws_ecs_cluster" "app" {
  name = "unicycling-rulebook-${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "unicycling-rulebook-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "web" {
  name              = "/ecs/unicycling-rulebook-${var.environment}-web"
  retention_in_days = 30

  tags = {
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "sidekiq" {
  name              = "/ecs/unicycling-rulebook-${var.environment}-sidekiq"
  retention_in_days = 30

  tags = {
    Environment = var.environment
  }
}

# ---- Container definition helpers ----

locals {
  ssm_prefix = "/unicycling-rulebook/${var.environment}"

  # Sensitive values — injected from SSM Parameter Store at task launch.
  # Create each parameter before scaling services up:
  #   aws ssm put-parameter --name "/unicycling-rulebook/{env}/SECRET_KEY_BASE" \
  #     --type SecureString --value "..." --region us-west-2
  ssm_secret_names = [
    "SECRET_KEY_BASE", "SECRET",
    "DATABASE_HOST", "POSTGRES_USER", "POSTGRES_PASSWORD", "POSTGRES_DB",
    "RULEBOOK_CREATION_ACCESS_CODE",
    "MAIL_SERVER", "MAIL_PORT", "MAIL_DOMAIN", "MAIL_USERNAME", "MAIL_PASSWORD",
    "MAIL_FULL_EMAIL", "MAIL_AUTHENTICATION", "MAIL_TLS",
    "ROLLBAR_ACCESS_TOKEN",
    "GOOGLE_ANALYTICS_TRACKING_ID", "GOOGLE_ANALYTICS_4_TRACKING_ID",
    "RECAPTCHA_SITE_KEY", "RECAPTCHA_SECRET_KEY",
    "AWS_REGION", "AWS_BUCKET", "AWS_ACCESS_KEY", "AWS_SECRET_ACCESS_KEY",
    "MAILJET_API_KEY", "MAILJET_SECRET_KEY", "MAILJET_DEFAULT_FROM",
  ]

  container_secrets = [
    for name in local.ssm_secret_names : {
      name      = name
      valueFrom = "arn:aws:ssm:us-west-2:${data.aws_caller_identity.current.account_id}:parameter${local.ssm_prefix}/${name}"
    }
  ]

  # Non-sensitive config set directly in the task definition.
  container_environment = [
    { name = "RAILS_ENV",           value = var.rails_env },
    { name = "PORT",                value = "3000" },
    { name = "RAILS_LOG_TO_STDOUT", value = "1" },
    { name = "RAILS_MAX_THREADS",   value = "5" },
    { name = "REDIS_HOST",          value = data.aws_elasticache_replication_group.redis.primary_endpoint_address },
    { name = "REDIS_PORT",          value = "6379" },
    { name = "REDIS_DB",            value = tostring(var.redis_db) },
    { name = "DOMAIN",              value = var.domain },
    # ALB terminates SSL; the app itself runs plain HTTP.
    { name = "SSL_ENABLED",         value = "false" },
  ]
}

# ---- Task definitions ----

resource "aws_ecs_task_definition" "web" {
  family                   = "unicycling-rulebook-${var.environment}-web"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([{
    name      = "web"
    image     = "${var.ecr_repository_url}:${var.image_tag}"
    essential = true

    portMappings = [{ containerPort = 3000, protocol = "tcp" }]

    environment = concat(local.container_environment, [
      { name = "WEB_CONCURRENCY", value = "1" },
    ])
    secrets = local.container_secrets

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.web.name
        "awslogs-region"        = "us-west-2"
        "awslogs-stream-prefix" = "web"
      }
    }
  }])

  tags = { Environment = var.environment }
}

resource "aws_ecs_task_definition" "sidekiq" {
  family                   = "unicycling-rulebook-${var.environment}-sidekiq"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([{
    name      = "sidekiq"
    image     = "${var.ecr_repository_url}:${var.image_tag}"
    essential = true
    command   = ["bundle", "exec", "sidekiq"]

    environment = local.container_environment
    secrets     = local.container_secrets

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.sidekiq.name
        "awslogs-region"        = "us-west-2"
        "awslogs-stream-prefix" = "sidekiq"
      }
    }
  }])

  tags = { Environment = var.environment }
}

# ---- ECS services ----
# desired_count starts at 0 — scale up after SSM parameters are populated.
# task_definition and desired_count are excluded from lifecycle management so
# that CircleCI deployments (Phase 4) can update them without terraform reverting.

resource "aws_ecs_service" "web" {
  name            = "unicycling-rulebook-${var.environment}-web"
  cluster         = aws_ecs_cluster.app.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = 0
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs.arn
    container_name   = "web"
    container_port   = 3000
  }

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }

  tags = { Environment = var.environment }
}

resource "aws_ecs_service" "sidekiq" {
  name            = "unicycling-rulebook-${var.environment}-sidekiq"
  cluster         = aws_ecs_cluster.app.id
  task_definition = aws_ecs_task_definition.sidekiq.arn
  desired_count   = 0
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }

  tags = { Environment = var.environment }
}
