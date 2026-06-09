output "alb_dns_name" {
  description = "ALB DNS name — use this to smoke-test before DNS cutover"
  value       = aws_lb.app.dns_name
}

output "acm_certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate_validation.app.certificate_arn
}

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.app.arn
}
