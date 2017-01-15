resource "aws_vpc_dhcp_options" "demo" {
  domain_name         = "${var.domain_name}"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags {
    Name      = "demo"
    terraform = "true"
  }
}

# DHCP association
resource "aws_vpc_dhcp_options_association" "demo" {
  vpc_id          = "${aws_vpc.demo.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.demo.id}"
}
