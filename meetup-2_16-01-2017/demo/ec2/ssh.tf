resource "aws_key_pair" "demo" {
  key_name   = "demo"
  public_key = "${file(var.ssh_public_key)}"
}
