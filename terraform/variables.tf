variable "environment" {
  type        = string
  description = "Environment name (prod or staging)"

  validation {
    condition     = contains(["prod", "staging"], var.environment)
    error_message = "environment must be prod or staging"
  }
}

variable "rails_env" {
  type        = string
  description = "The rails environment to set on the server"
}

variable "alb_domain" {
  type        = string
  description = "Name the ALB serves, e.g. rulebook-alb.unicycling-software.com. The public domain becomes a CNAME to this."
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

variable "rds_security_group_id" {
  type        = string
  description = "Security group ID attached to the shared RDS instance (dbaccess)"
}

variable "ecr_repository_url" {
  type        = string
  description = "ECR repository URL (without tag) — from terraform/global output ecr_repository_url"
}

variable "image_tag" {
  type        = string
  description = "Image tag to deploy. Not set in tfvars: bin/tf supplies the tag of the image currently running in ECS (or IMAGE_TAG)."
}

variable "redis_db" {
  type        = number
  description = "Redis database number for the web/sidekiq processes (sidekiq uses redis_db+1)"
}

