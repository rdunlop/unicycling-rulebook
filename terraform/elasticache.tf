data "aws_elasticache_replication_group" "redis" {
  replication_group_id = var.elasticache_cluster_id
}

# Allow ECS tasks to reach the shared ElastiCache replication group.
# Each environment adds its own rule, so both prod and staging rules coexist in the same SG.
resource "aws_security_group_rule" "redis_from_ecs" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = var.elasticache_security_group_id
  source_security_group_id = aws_security_group.ecs_tasks.id
  description              = "Redis from ECS tasks (${var.environment})"
}

output "redis_host" {
  description = "ElastiCache Redis primary endpoint"
  value       = data.aws_elasticache_replication_group.redis.primary_endpoint_address
}
