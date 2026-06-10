environment           = "staging"
domain                = "rulebooktest.unicycling-software.com"
subject_alt_names     = ["*.rulebooktest.unicycling-software.com"]

# Fill these in from the AWS CLI lookup commands in the README
ec2_instance_id       = "i-08e422724fb3f27c1"
ec2_security_group_id = "sg-21781344"
vpc_id                = "vpc-e113c084"
subnet_ids            = ["subnet-39963f5c", "subnet-16e82761", "subnet-1f6f8346", "subnet-ba154f92"]
zone_id               = "Z1NYSHL8JOE6MN"
elasticache_cluster_id = "rulebooks"
elasticache_security_group_id = "sg-0d123faecb3577be0"
