output "instance_name" {
  description = "The name for Cloud SQL instance"
  value       = module.postgresql-db.instance_name
}

output "psql_conn" {
  description = "The connection name of the master instance to be used in connection strings"
  value       = module.postgresql-db.instance_connection_name
}

output "psql_user_name" {
  description = "The name of the default user"
  value       = var.pguser
}

output "psql_user_pass" {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  value       = module.postgresql-db.generated_user_password
}

output "public_ip_address" {
  description = "The first public (PRIMARY) IPv4 address assigned for the master instance"
  value       = module.postgresql-db.public_ip_address
}

output "private_ip_address" {
  description = "The first private (PRIVATE) IPv4 address assigned for the master instance"
  value       = module.postgresql-db.private_ip_address
}
