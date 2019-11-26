data "aws_availability_zones" "available" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "1.14.0"
  name = "cluster-vpc"
  cidr = "${local.vpc_cidr}"
  azs = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}"]
  private_subnets = ["${data.template_file.private_cidrs.*.rendered}"]
  public_subnets = ["${data.template_file.public_cidrs.*.rendered}"]
  enable_nat_gateway = true
  single_nat_gateway = true
  tags = "${merge(local.tags, map("kubernetes.io/cluster/${var.prefix}", "shared"))}"
}
