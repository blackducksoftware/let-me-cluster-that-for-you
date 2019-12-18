output "name" {
  value       = local.instance_name
  description = "The name for Cloud SQL instance"
}

output "psql_conn" {
  value       = module.postgresql-db.instance_connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "psql_user_pass" {
  value       = module.postgresql-db.generated_user_password
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
}
