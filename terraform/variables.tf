variable "environment" {
  type        = string
  description = "Environment name (prod or staging)"

  validation {
    condition     = contains(["prod", "staging"], var.environment)
    error_message = "environment must be prod or staging"
  }
}

variable "rails_env" {
  type = string
  description = "The rails environment to set on the server"
}

variable "domain" {
  type        = string
  description = "Primary domain for the ACM certificate and Route53 record"
}

variable "subject_alt_names" {
  type        = list(string)
  default     = []
  description = "Additional SANs for the ACM certificate (e.g. wildcard)"
}

variable "zone_id" {
  type        = string
  description = "Route53 hosted zone ID"
}

variable "ec2_instance_id" {
  type        = string
  description = "ID of the existing EC2 instance to register in the ALB target group"
}

variable "ec2_security_group_id" {
  type        = string
  description = "ID of the existing EC2 security group; an ingress rule will be added allowing port 80 from the ALB"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the ALB will be created"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs (minimum 2, in different AZs) for the ALB"
}

variable "elasticache_cluster_id" {
  type        = string
  description = "ID of the existing shared ElastiCache Redis replication group"
}

variable "elasticache_security_group_id" {
  type        = string
  description = "Security group ID attached to the existing ElastiCache replication group"
}

variable "ecr_repository_url" {
  type        = string
  description = "ECR repository URL (without tag) — from terraform/global output ecr_repository_url"
}

variable "image_tag" {
  type        = string
  description = "Image tag to deploy (git SHA from CircleCI)"
}

variable "redis_db" {
  type        = number
  description = "Redis database number for the web/sidekiq processes (sidekiq uses redis_db+1)"
}

variable "ecs_traffic_weight" {
  type        = number
  default     = 0
  description = "Weight of traffic sent to ECS (0-100). EC2 receives 100 minus this value. Set to 100 for full ECS cutover."

  validation {
    condition     = var.ecs_traffic_weight >= 0 && var.ecs_traffic_weight <= 100
    error_message = "ecs_traffic_weight must be between 0 and 100."
  }
}
