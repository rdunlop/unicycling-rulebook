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
