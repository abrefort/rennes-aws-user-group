output "vpc_id" {
  value = "${aws_vpc.demo.id}"
}

output "subnet_ids" {
  value = ["${aws_subnet.demo.*.id}"]
}
