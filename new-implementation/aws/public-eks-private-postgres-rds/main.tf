
resource "random_string" "suffix" {
  length  = 4
  special = false
}
locals {
  /* Local variables */
  name = "${var.cluster_name}-${random_string.suffix.result}"
}


module "eks-public" {
  source             = "../backends/eks"
  cluster_name       = "${local.name}"
  kubernetes_version = var.kubernetes_version
  region             = var.region
  workers            = var.workers
  instance_type      = var.instance_type
}

module "postgres-rds" {
  source           = "../backends/postgres-rds"
  region           = var.region
  db_name          = var.cluster_name
  db_username      = var.db_username
  db_password      = var.db_password
  postgres_version = var.postgres_version
  security_groups  = "${module.eks-public.worker_node_security_group_id}"
  subnets          = "${module.eks-public.vpc_database_subnets}"
  vpc_id           = "${module.eks-public.vpc_id}"
}