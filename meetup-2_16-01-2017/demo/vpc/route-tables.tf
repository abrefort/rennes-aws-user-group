resource "aws_route_table" "demo" {
  vpc_id = "${aws_vpc.demo.id}"

  tags {
    Name      = "demo"
    terraform = "true"
  }
}

resource "aws_route_table_association" "demo" {
  subnet_id      = "${element(aws_subnet.demo.*.id, count.index)}"
  route_table_id = "${aws_route_table.demo.id}"

  count = "${length(var.subnets_cidrs)}"
}

# default route to internet
resource "aws_route" "demo-igw" {
  route_table_id         = "${aws_route_table.demo.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.demo.id}"
}
