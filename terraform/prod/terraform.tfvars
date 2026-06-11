environment           = "prod"
domain                = "rulebook.unicycling-software.com"
rails_env             = "production"
subject_alt_names     = [
  "*.rulebook.unicycling-software.com",
  "committees.unicycling-software.com",
  "*.committees.unicycling-software.com",
]

# Fill these in from the AWS CLI lookup commands in the README
ec2_instance_id       = "i-088dda906cd2deb5d"
ec2_security_group_id = "sg-21781344"
vpc_id                = "vpc-e113c084"
subnet_ids            = ["subnet-39963f5c", "subnet-16e82761", "subnet-1f6f8346", "subnet-ba154f92"]
zone_id               = "Z1NYSHL8JOE6MN"
elasticache_cluster_id        = "rulebooks"
elasticache_security_group_id = "sg-0d123faecb3577be0"
ecr_repository_url            = "197931692346.dkr.ecr.us-west-2.amazonaws.com/unicycling-rulebook"
image_tag                     = "38102f3d4f76f7e08d21850a52dcdb5bac2d5efd"
redis_db                      = 0
rds_security_group_id         = "sg-d51560b0"
ecs_traffic_weight = 100
