
data "aws_route53_zone" "app_zone" {
  name         = "${var.app_domain}"
}

resource "aws_route53_record" "frontend" {
  zone_id = data.aws_route53_zone.app_zone.zone_id
  name    = var.frontend_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.app_cloudfront.domain_name
    zone_id                = aws_cloudfront_distribution.app_cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "api" {
    zone_id = data.aws_route53_zone.app_zone.zone_id
    name = var.backend_name
    type = "A"

    alias {
        name                   = aws_alb.alb.dns_name
        zone_id                = aws_alb.alb.zone_id
        evaluate_target_health = true
    }
}
