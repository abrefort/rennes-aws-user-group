variable "vpc_cidr" {}

variable "domain_name" {}

variable "availability_zones" {
  type = "list"
}

variable "subnets_cidrs" {
  type = "list"
}
