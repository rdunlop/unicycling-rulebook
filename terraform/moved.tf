# Resources that moved into the unicycling-infra modules. Applying these updates state only, not infrastructure.
# Remove each block once every environment has been applied past this change.

# ---- alb-ingress ----

moved {
  from = aws_security_group.alb
  to   = module.alb.aws_security_group.alb
}

moved {
  from = aws_lb.app
  to   = module.alb.aws_lb.app
}

moved {
  from = aws_lb_target_group.ecs
  to   = module.alb.aws_lb_target_group.ecs
}

moved {
  from = aws_lb_listener.http
  to   = module.alb.aws_lb_listener.http
}

moved {
  from = aws_lb_listener.https
  to   = module.alb.aws_lb_listener.https
}

moved {
  from = aws_acm_certificate.app
  to   = module.alb.aws_acm_certificate.app
}

moved {
  from = aws_route53_record.acm_validation
  to   = module.alb.aws_route53_record.acm_validation
}

moved {
  from = aws_acm_certificate_validation.app
  to   = module.alb.aws_acm_certificate_validation.app
}

# Legacy EC2 path removed: the 0% target group, its instance attachment, and the port 80 rule on the EC2 security group.
removed {
  from = aws_lb_target_group.app
  lifecycle {
    destroy = true
  }
}

removed {
  from = aws_lb_target_group_attachment.app
  lifecycle {
    destroy = true
  }
}

removed {
  from = aws_security_group_rule.ec2_from_alb
  lifecycle {
    destroy = true
  }
}

# The apex A alias is deleted in AWS before this apply (see the change notes). Forget it here so Terraform
# does not try to delete it again, and let the module create the apex CNAME in its place.
removed {
  from = aws_route53_record.app
  lifecycle {
    destroy = false
  }
}

# ---- ecs-app ----

moved {
  from = aws_ecs_cluster.app
  to   = module.ecs_app.aws_ecs_cluster.app
}

moved {
  from = aws_cloudwatch_log_group.web
  to   = module.ecs_app.aws_cloudwatch_log_group.web
}

moved {
  from = aws_cloudwatch_log_group.sidekiq
  to   = module.ecs_app.aws_cloudwatch_log_group.sidekiq
}

moved {
  from = aws_security_group.ecs_tasks
  to   = module.ecs_app.aws_security_group.ecs_tasks
}

moved {
  from = aws_security_group_rule.rds_from_ecs
  to   = module.ecs_app.aws_security_group_rule.database_from_ecs
}

moved {
  from = aws_security_group_rule.redis_from_ecs
  to   = module.ecs_app.aws_security_group_rule.redis_from_ecs
}

moved {
  from = aws_iam_role.ecs_execution
  to   = module.ecs_app.aws_iam_role.ecs_execution
}

moved {
  from = aws_iam_role_policy_attachment.ecs_execution_managed
  to   = module.ecs_app.aws_iam_role_policy_attachment.ecs_execution_managed
}

moved {
  from = aws_iam_role_policy.ecs_execution_ssm
  to   = module.ecs_app.aws_iam_role_policy.ecs_execution_ssm
}

moved {
  from = aws_iam_role.ecs_task
  to   = module.ecs_app.aws_iam_role.ecs_task
}

# Inline policy: the module names it "app-permissions" (this was "ecs-exec"), so this one is replaced
# in place. The replacement is the ECS Exec permission set only.
moved {
  from = aws_iam_role_policy.ecs_task_exec_command
  to   = module.ecs_app.aws_iam_role_policy.ecs_task_permissions
}

moved {
  from = aws_ecs_task_definition.web
  to   = module.ecs_app.aws_ecs_task_definition.web
}

moved {
  from = aws_ecs_task_definition.sidekiq
  to   = module.ecs_app.aws_ecs_task_definition.sidekiq
}

moved {
  from = aws_ecs_service.web
  to   = module.ecs_app.aws_ecs_service.web
}

moved {
  from = aws_ecs_service.sidekiq
  to   = module.ecs_app.aws_ecs_service.sidekiq
}

moved {
  from = aws_iam_role.eventbridge_ecs
  to   = module.ecs_app.aws_iam_role.eventbridge_ecs[0]
}

moved {
  from = aws_iam_role_policy.eventbridge_ecs
  to   = module.ecs_app.aws_iam_role_policy.eventbridge_ecs[0]
}

moved {
  from = aws_cloudwatch_event_rule.update_proposal_states
  to   = module.ecs_app.aws_cloudwatch_event_rule.scheduled["update-proposal-states"]
}

moved {
  from = aws_cloudwatch_event_target.update_proposal_states
  to   = module.ecs_app.aws_cloudwatch_event_target.scheduled["update-proposal-states"]
}
