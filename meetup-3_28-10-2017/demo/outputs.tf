output "cloudfront_domain_name" {
  value = "${aws_cloudfront_distribution.demo.domain_name}"
}
