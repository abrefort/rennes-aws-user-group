# Instances
resource "aws_security_group" "demo" {
  name        = "demo"
  vpc_id      = "${var.vpc_id}"
  description = "Demo security group"

  tags {
    Name      = "demo"
    terraform = "true"
  }
}

resource "aws_security_group_rule" "demo-egress-all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.demo.id}"
}

resource "aws_security_group_rule" "demo-ingress-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.demo.id}"
}

resource "aws_security_group_rule" "web-ingress-http-all" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.demo.id}"
}

resource "aws_security_group_rule" "web-ingress-http-elb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.demo-elb.id}"
  security_group_id        = "${aws_security_group.demo.id}"
}

# ELB
resource "aws_security_group" "demo-elb" {
  name        = "demo-elb"
  vpc_id      = "${var.vpc_id}"
  description = "Demo security group"

  tags {
    Name      = "demo-elb"
    terraform = "true"
  }
}

resource "aws_security_group_rule" "demo-elb-egress-demo" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.demo.id}"
  security_group_id        = "${aws_security_group.demo-elb.id}"
}

resource "aws_security_group_rule" "demo-elb-ingress-http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.demo-elb.id}"
}
