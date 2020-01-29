output "kubeconfig_path" {
  description = "Path to kubeconfig file"
  value       = module.custom_gke.kubeconfig_path
}

output "psql_conn" {
  description = "The connection name of the master instance to be used in connection strings"
  sensitive   = true
  value       = module.custom_postgresql_db.psql_conn
}

output "psql_user_pass" {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  sensitive   = true
  value       = module.custom_postgresql_db.psql_user_pass
}

output "instance_name" {
  description = "The name for Cloud SQL instance"
  value       = module.custom_postgresql_db.instance_name
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.custom_gke.cluster_name
}




output "kubernetes_endpoint" {
  description = "The cluster endpoint"
  sensitive   = true
  value       = module.custom_gke.kubernetes_endpoint
}

output "network_name" {
  description = "The name of the VPC being created"
  value       = module.custom_gke.network_name
}

output "subnet_name" {
  description = "The name of the subnet being created"
  value       = module.custom_gke.subnet_name
}

output "public_ip_address" {
  description = "The first public (PRIMARY) IPv4 address assigned for the master instance"
  sensitive   = true
  value       = module.custom_postgresql_db.public_ip_address
}

output "private_ip_address" {
  description = "The first private (PRIVATE) IPv4 address assigned for the master instance"
  sensitive   = true
  value       = module.custom_postgresql_db.private_ip_address
}
