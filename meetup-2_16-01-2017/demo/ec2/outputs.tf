output "elb_endpoint" {
  value = "${aws_elb.demo.dns_name}"
}
