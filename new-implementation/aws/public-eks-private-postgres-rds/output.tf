output "master-url" {
  value = "${module.eks-public.master-url}"
}

output "cluster-auth-config" {
  value = "${module.eks-public.cluster-auth-config}"
}

output "cluster-config" {
  value = "${module.eks-public.cluster-config}"
}

output "worker_node_security_group_id" {
  value = "${module.eks-public.worker_node_security_group_id}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_public_subnets" {
  value = "${module.vpc.vpc_public_subnets}"
}

output "vpc_database_subnets" {
  value = "${module.vpc.vpc_database_subnets}"
}

output "db_endpoint" {
  value = "${module.postgres-rds.db_endpoint}"
}
