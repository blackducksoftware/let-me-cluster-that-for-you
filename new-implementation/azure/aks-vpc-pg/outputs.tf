# MAIN OUTPUTS
output "kubeconfig_path" {
  value = module.aks-with-vpc.kubeconfig_path
}

output "psql_user_pass" {
  value = module.db-on-vpc.password
}

output "psql_conn" {
 description = "The connection name of the master instance to be used in connection strings"
 sensitive   = true
 value       = module.db-on-vpc.fqdn
}
