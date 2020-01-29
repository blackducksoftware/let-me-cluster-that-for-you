# MAIN OUTPUTS
output "kubeconfig_path" {
  value = module.aks-with-vpc.kubeconfig_path
}

output "psql_conn" {
 description = "The connection name of the master instance to be used in connection strings"
 sensitive   = true
 value       = module.db-on-vpc.fqdn
}

# TODO: generate a random password; do that in submodule too
#output "psql_user_pass" {
#  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
#  sensitive   = true
#  value       = module.custom_postgresql_db.psql_user_pass
#}
