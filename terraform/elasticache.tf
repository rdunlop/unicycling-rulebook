data "aws_elasticache_replication_group" "redis" {
  replication_group_id = var.elasticache_cluster_id
}

output "redis_host" {
  description = "ElastiCache Redis primary endpoint"
  value       = data.aws_elasticache_replication_group.redis.primary_endpoint_address
}
