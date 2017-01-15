resource "aws_subnet" "demo" {
  availability_zone       = "${var.availability_zones[count.index]}"
  vpc_id                  = "${aws_vpc.demo.id}"
  cidr_block              = "${var.subnets_cidrs[count.index]}"
  map_public_ip_on_launch = "True"

  tags {
    Name      = "demo.${var.availability_zones[count.index]}"
    terraform = "true"
  }

  count = "${length(var.subnets_cidrs)}"
}
