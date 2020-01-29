output "pg_server_name" {
  value = azurerm_postgresql_server.pg_server.name
}

output "fqdn" {
  value = azurerm_postgresql_server.fqdn
}
