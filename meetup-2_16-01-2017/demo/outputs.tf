output "elb_endpoint" {
  value = "${module.ec2.elb_endpoint}"
}
