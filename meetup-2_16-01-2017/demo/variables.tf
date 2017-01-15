variable "aws_region" {
  default = "eu-west-1"
}

variable "aws_profile" {
  default = "terraform-demo"
}

variable "ssh_public_key" {
  default = "~/.ssh/keys/terraform-demo.pub"
}
