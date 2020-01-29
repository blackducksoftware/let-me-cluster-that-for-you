provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
}

data "template_file" "public_cidrs" {
  count    = 3
  template = "${cidrsubnet("10.0.0.0/16", 8, count.index)}"
}

data "template_file" "database_cidrs" {
  count    = 2
  template = "${cidrsubnet("10.0.0.0/16", 8, count.index + 3)}"
}

# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.23.0

module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "2.23.0"
  name                 = var.vpc_name
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = "${data.template_file.public_cidrs.*.rendered}"
  database_subnets     = "${data.template_file.database_cidrs.*.rendered}"
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
}