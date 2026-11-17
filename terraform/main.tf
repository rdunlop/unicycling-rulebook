# unicycling-rulebook infrastructure, built from the shared modules in unicycling-infra.
# Pinned to a tag: bump the ref deliberately, then check the plan before applying.

module "alb" {
  source = "git::https://github.com/rdunlop/unicycling-infra.git//modules/alb-ingress?ref=v0.2.0"

  app_name          = "unicycling-rulebook"
  environment       = var.environment
  vpc_id            = var.vpc_id
  subnet_ids        = var.subnet_ids
  zone_id           = var.zone_id
  domain            = var.domain
  alb_domain        = var.alb_domain
  subject_alt_names = var.subject_alt_names
  # The rulebook's wildcard (*.<domain>) is managed outside Terraform, so the module does not create it.
  wildcard_domain = null
  # The legacy EC2 target group is gone. Its 0% share of traffic is dropped in this change.
  legacy_ec2            = null
  ecs_target_group_name = "unicycling-rulebook-${var.environment}-ecs"
}

module "ecs_app" {
  source = "git::https://github.com/rdunlop/unicycling-infra.git//modules/ecs-app?ref=v0.2.0"

  app_name                   = "unicycling-rulebook"
  environment                = var.environment
  region                     = "us-west-2"
  vpc_id                     = var.vpc_id
  subnet_ids                 = var.subnet_ids
  alb_security_group_id      = module.alb.alb_security_group_id
  target_group_arn           = module.alb.target_group_arn
  database_security_group_id = var.rds_security_group_id
  redis_security_group_id    = var.elasticache_security_group_id
  ecr_repository_url         = var.ecr_repository_url
  image_tag                  = var.image_tag

  web_cpu        = 512
  web_memory     = 1024
  sidekiq_cpu    = 512
  sidekiq_memory = 1024

  # Sidekiq keeps the command it has always run. The module default adds "-C config/sidekiq.yml".
  sidekiq_command = ["bundle", "exec", "sidekiq"]

  container_insights = var.environment == "staging" ? "disabled" : "enabled"

  environment_vars = [
    { name = "RAILS_ENV", value = var.rails_env },
    { name = "PORT", value = "3000" },
    { name = "RAILS_LOG_TO_STDOUT", value = "1" },
    { name = "RAILS_MAX_THREADS", value = "5" },
    { name = "RAILS_SERVE_STATIC_FILES", value = "true" },
    { name = "REDIS_HOST", value = data.aws_elasticache_replication_group.redis.primary_endpoint_address },
    { name = "REDIS_PORT", value = "6379" },
    { name = "REDIS_DB", value = tostring(var.redis_db) },
    { name = "DOMAIN", value = var.domain },
    # ALB terminates SSL; the app itself runs plain HTTP.
    { name = "SSL_ENABLED", value = "false" },
  ]

  secret_names = [
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

  scheduled_tasks = [
    {
      name                = "update-proposal-states"
      description         = "Daily rake update_proposal_states (replaces whenever cron)"
      schedule_expression = "cron(0 0 * * ? *)"
      command             = ["bundle", "exec", "rake", "update_proposal_states"]
    },
  ]
}
