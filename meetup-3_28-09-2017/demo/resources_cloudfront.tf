resource "aws_cloudfront_distribution" "demo" {
  price_class         = "PriceClass_200"
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "good.php"

  aliases = ["${var.cloudfront_alias}"]

  web_acl_id = "${aws_waf_web_acl.demo.id}"

  origin {
    domain_name = "${var.origin_domain_name}"
    origin_id   = "demo"

    custom_origin_config {
      http_port  = 80
      https_port = 443

      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET", "OPTIONS"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = "demo"

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type = "origin-response"
      lambda_arn = "${aws_lambda_function.edge.qualified_arn}"
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1"
  }

  tags {
    environement = "demo"
  }
}
