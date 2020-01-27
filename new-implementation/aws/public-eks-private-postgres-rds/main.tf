
resource "random_string" "suffix" {
  length  = 4
  special = false
}
locals {
  /* Local variables */
  name = "${var.cluster_name}-${random_string.suffix.result}"
}

# common module for eks and rds
module "vpc" {
  source   = "../backends/vpc"
  region   = var.region
  vpc_name = local.name
}

module "eks-public" {
  source             = "../backends/eks"
  cluster_name       = "${local.name}"
  kubernetes_version = var.kubernetes_version
  region             = var.region
  workers            = var.workers
  instance_type      = var.instance_type
  subnets            = "${module.vpc.vpc_public_subnets}"
  vpc_id             = "${module.vpc.vpc_id}"
}

module "postgres-rds" {
  source           = "../backends/postgres-rds"
  region           = var.region
  public_access    = true
  db_name          = var.cluster_name
  db_username      = var.db_username
  db_password      = var.db_password
  postgres_version = var.postgres_version
  subnets          = "${module.vpc.vpc_database_subnets}"
  vpc_id           = "${module.vpc.vpc_id}"
}