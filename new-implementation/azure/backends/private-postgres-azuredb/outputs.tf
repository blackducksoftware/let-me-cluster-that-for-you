output "postgresql_hosts" {
  description = "Postgres host"
  value       = azurerm_postgresql_server.pg[*].fqdn
}

