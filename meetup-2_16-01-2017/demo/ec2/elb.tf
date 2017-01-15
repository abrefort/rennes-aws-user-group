resource "aws_elb" "demo" {
  name            = "demo"
  subnets         = ["${var.subnet_ids}"]
  security_groups = ["${aws_security_group.demo-elb.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  tags {
    Name      = "demo"
    terraform = "true"
  }
}
