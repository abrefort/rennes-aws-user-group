# VPC
resource "aws_vpc" "demo" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name      = "demo"
    terraform = "true"
  }
}

# IGW
resource "aws_internet_gateway" "demo" {
  vpc_id = "${aws_vpc.demo.id}"

  tags {
    Name      = "demo"
    terraform = "true"
  }
}
