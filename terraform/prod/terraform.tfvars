environment = "prod"
domain      = "rulebook.unicycling-software.com"
alb_domain  = "rulebook-alb.unicycling-software.com"
rails_env   = "production"
subject_alt_names = [
  "*.rulebook.unicycling-software.com",
  "committees.unicycling-software.com",
  "*.committees.unicycling-software.com",
]

vpc_id = "vpc-e113c084"
# Two public subnets in different AZs (us-west-2b and us-west-2d). The ALB needs at least two.
subnet_ids                    = ["subnet-16e82761", "subnet-ba154f92"]
zone_id                       = "Z1NYSHL8JOE6MN"
elasticache_cluster_id        = "rulebooks"
elasticache_security_group_id = "sg-0d123faecb3577be0"
ecr_repository_url            = "197931692346.dkr.ecr.us-west-2.amazonaws.com/unicycling-rulebook"
redis_db                      = 0
rds_security_group_id         = "sg-d51560b0"
