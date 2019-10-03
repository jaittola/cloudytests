locals {
    s3_origin_id = "cloudyTestingOriginId"
}

resource "aws_cloudfront_distribution" "app_cloudfront" {
    origin {
        domain_name = "${aws_s3_bucket.frontend.bucket_regional_domain_name}"
        origin_id   = "${local.s3_origin_id}"
    }
    enabled = true
    is_ipv6_enabled = true
    default_root_object = "index.html"

    price_class = var.cloudfront_priceclass

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    viewer_certificate {
        acm_certificate_arn = var.cloudfront_cert_arn
        ssl_support_method = "sni-only"
    }

    aliases = [ var.frontend_name ]

    default_cache_behavior {
        allowed_methods  = ["GET", "HEAD", "OPTIONS"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = "${local.s3_origin_id}"

        forwarded_values {
            query_string = false

            cookies {
                forward = "none"
            }
        }

        compress = true
        viewer_protocol_policy = "redirect-to-https"
        default_ttl            = 1000
    }
}
