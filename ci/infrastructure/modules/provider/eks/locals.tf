locals {
#  cluster_name = "${var.prefix}-cluster"
  aws_region = "${length(var.az_region) > 0 ? "${var.az_region}" : "us-east-1"}"
  vpc_cidr = "${length(var.az_vpc_cidr) > 0 ? "${var.az_vpc_cidr}" : "10.0.0.0/16"}"
  subnet_cidr = "${cidrsubnet(local.vpc_cidr, 8, 1)}"
  workerimagesize = "${length(var.az_worker_image) > 0 ? "${var.az_worker_image}" : "t2.large"}"
  version = "${length(var.eks_version) > 0 ? "${var.eks_version}" : "1.14"}"

  tags = {
    Name = "${var.prefix} EKS Cluster"
  }
}

data "template_file" "private_cidrs" {
  count = 2
  template = "${cidrsubnet(local.vpc_cidr, 8, count.index)}"
}

data "template_file" "public_cidrs" {
  count = 2
  template = "${cidrsubnet(local.vpc_cidr, 8, count.index + 2)}"
}
