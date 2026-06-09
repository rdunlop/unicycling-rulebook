variable "environment" {
  type        = string
  description = "Environment name (prod or staging)"

  validation {
    condition     = contains(["prod", "staging"], var.environment)
    error_message = "environment must be prod or staging"
  }
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
