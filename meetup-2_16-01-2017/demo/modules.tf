module "vpc" {
  source = "./vpc"

  vpc_cidr           = "10.90.0.0/16"
  domain_name        = "terraform.demo"
  availability_zones = ["eu-west-1a", "eu-west-1b"]
  subnets_cidrs      = ["10.90.20.0/24", "10.90.30.0/24"]
}

module "ec2" {
  source = "./ec2"

  vpc_id         = "${module.vpc.vpc_id}"
  subnet_ids     = "${module.vpc.subnet_ids}"
  ssh_public_key = "${var.ssh_public_key}"
}
