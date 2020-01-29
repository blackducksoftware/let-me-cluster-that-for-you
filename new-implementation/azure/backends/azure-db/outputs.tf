output "pg_server_name" {
  value = azurerm_postgresql_server.pg_server.name
}

output "password" {
  value = azurerm_postgresql_server.pg_server.administrator_login_password
}