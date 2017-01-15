# Get recent ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-yakkety-16.10-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create launch configuration
resource "aws_launch_configuration" "demo" {
  name            = "demo"
  image_id        = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.nano"
  key_name        = "${aws_key_pair.demo.key_name}"
  user_data       = "${file("${path.module}/files/userdata.sh")}"
  security_groups = ["${aws_security_group.demo.id}"]

  # create new launch configuration before destroying old one
  lifecycle {
    create_before_destroy = true
  }
}

# Create autoscaling
resource "aws_autoscaling_group" "demo" {
  vpc_zone_identifier       = ["${var.subnet_ids}"]
  name                      = "demo"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 600
  health_check_type         = "ELB"
  desired_capacity          = 2
  launch_configuration      = "${aws_launch_configuration.demo.name}"
  load_balancers            = ["${aws_elb.demo.id}"]

  tag {
    key                 = "Name"
    value               = "demo"
    propagate_at_launch = true
  }

  tag {
    key                 = "terraform"
    value               = "true"
    propagate_at_launch = false
  }
}
