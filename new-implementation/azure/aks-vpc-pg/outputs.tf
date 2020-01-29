output "kubeconfig_path" {
  value = module.aks-with-vpc.kubeconfig_path
}

#output "psql_conn" {
#  description = "The connection name of the master instance to be used in connection strings"
#  sensitive   = true
#  value       = module.custom_postgresql_db.psql_conn
#}
#
#output "psql_user_pass" {
#  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
#  sensitive   = true
#  value       = module.custom_postgresql_db.psql_user_pass
#}
#
#output "instance_name" {
#  description = "The name for Cloud SQL instance"
#  value       = module.custom_postgresql_db.instance_name
#}
#
#output "cluster_name" {
#  description = "Cluster name"
#  value       = module.custom_gke.cluster_name
#}
#
