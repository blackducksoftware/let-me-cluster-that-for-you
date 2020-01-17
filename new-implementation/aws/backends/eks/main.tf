//local variables

locals {
  instance_create_timeout = "60"
}

data "aws_availability_zones" "available" {
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}


data "template_file" "public_cidrs" {
  count    = 3
  template = "${cidrsubnet("10.0.0.0/16", 8, count.index)}"
}

data "template_file" "database_cidrs" {
  count    = 2
  template = "${cidrsubnet("10.0.0.0/16", 8, count.index + 3)}"
}

// ssh keypair
resource "aws_key_pair" "keypair" {
  key_name   = var.cluster_name
  public_key = file(var.public_key_path)
}

module "vpc" {
  # https://github.com/terraform-aws-modules/terraform-aws-vpc/releases
  # https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.22.0
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.22.0"

  name                 = var.cluster_name
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  database_subnets     = "${data.template_file.database_cidrs.*.rendered}"
  public_subnets       = "${data.template_file.public_cidrs.*.rendered}"
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

provider "aws" {
  region  = var.region
}

provider "kubernetes" {
  host                   = element(concat(data.aws_eks_cluster.cluster[*].endpoint, list("")), 0)
  cluster_ca_certificate = base64decode(element(concat(data.aws_eks_cluster.cluster[*].certificate_authority.0.data, list("")), 0))
  token                  = element(concat(data.aws_eks_cluster_auth.cluster[*].token, list("")), 0)
  load_config_file       = false
  version                = "~> 1.10"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 8.1"

  cluster_name                   = "${var.cluster_name}"
  cluster_version                = "${var.kubernetes_version}"
  subnets                        = "${module.vpc.public_subnets}"
  vpc_id                         = "${module.vpc.vpc_id}"
  cluster_endpoint_public_access = "true"
  write_kubeconfig               = "true"
  config_output_path             = "../"
  manage_aws_auth                = true
  cluster_create_timeout         = "${local.instance_create_timeout}m"
  tags = {
    Name = "${var.cluster_name}"
  }
  worker_groups = [
    {
      worker_group_count   = 1
      instance_type        = "${length(var.instance_type) > 0 ? "var.instance_type" : "m4.large"}"
      asg_desired_capacity = "${length(var.workers) > 0 ? var.workers : 4}"
      asg_min_size         = "${length(var.workers) > 0 ? var.workers : 4}"
      asg_max_size         = 6
      root_volume_size     = "100"
      root_volume_type     = "gp2"
      public_ip            = "true"
      subnets              = "${module.vpc.public_subnets}"
      key_name             = "${var.cluster_name}"
    }
  ]
}
