# TODO: turn "cluster-auth-config" and "cluster-config" into "kubeconfig_path"
output "cluster-auth-config" {
  value = "${module.eks-public.cluster-auth-config}"
}

output "cluster-config" {
  value = "${module.eks-public.cluster-config}"
}

# output "kubeconfig_path" {
#   description = "Path to kubeconfig file"
#   value       = module.custom_gke.kubeconfig_path
# }

output "psql_conn" {
  description = "The connection name of the master instance to be used in connection strings"
  sensitive   = true
  value       = module.postgres-rds.db_endpoint
}

#output "psql_user_pass" {
#  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
#  sensitive   = true
#  value       = module.custom_postgresql_db.psql_user_pass
#}

#############################################################################
# DEBUG OUTPUTS

output "instance_name" {
  description = "The name for Cloud SQL instance"
  value       = module.custom_postgresql_db.name
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.eks-public.cluster_name
}

output "master-url" {
  value = "${module.eks-public.master-url}"
}

output "vpc_id" {
  value = "${module.eks-public.vpc_id}"
}
output "vpc_public_subnets" {
  value = "${module.eks-public.vpc_public_subnets}"
}

output "vpc_database_subnets" {
  value = "${module.eks-public.vpc_database_subnets}"
}

output "worker_node_security_group_id" {
  value = "${module.eks-public.worker_node_security_group_id}"
}
