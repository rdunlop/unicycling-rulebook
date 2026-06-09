resource "aws_route53_record" "app" {
  zone_id         = var.zone_id
  name            = var.domain
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = aws_lb.app.dns_name
    zone_id                = aws_lb.app.zone_id
    evaluate_target_health = true
  }
}
