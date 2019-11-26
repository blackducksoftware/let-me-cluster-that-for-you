/*
data "aws_availability_zones" "available" {}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}

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
*/

//  Create an SSH keypair
resource "aws_key_pair" "keypair" {
  key_name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  # This version is needed until support for teraform 12.x is implemented
  version = "2.2.1"
  cluster_name = "${var.prefix}"
  cluster_version = "${local.version}"
  subnets = ["${module.vpc.private_subnets}"]
  vpc_id = "${module.vpc.vpc_id}"
  config_output_path = "./"
  kubeconfig_name = "${var.prefix}"
  manage_aws_auth = "true"
  write_kubeconfig = "true"
  cluster_create_timeout = "${var.instance_create_timeout}m"
  tags = "${local.tags}"
  worker_groups = [
    {
      instance_type = "${local.workerimagesize}"
      asg_desired_capacity = "${var.workers}"
      asg_max_size  = "${var.workers}"
      autoscaling_enabled = "true"
      subnets = "${join(",", module.vpc.private_subnets)}"
      public_ip = "true"
      key_name = "${var.key_name}"
    }
  ]
  worker_group_count = "1"
#  worker_additional_security_group_ids = ["${aws_security_group.all_worker_mgmt.id}"]
}
