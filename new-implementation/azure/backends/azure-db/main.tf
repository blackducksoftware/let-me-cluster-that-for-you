resource "random_string" "postgresql_admin_password" {
  length  = 32
  special = false
  upper   = true
}

resource "azurerm_postgresql_server" "pg_server" {
  name                = var.pg_server_name
  location            = var.location
  resource_group_name = var.rg_name

  sku_name = var.pg_sku

  storage_profile {
    storage_mb            = var.storage_mb
    backup_retention_days = var.backup_retention_days
    geo_redundant_backup  = var.geo_redundant_backup
  }

  administrator_login          = var.administrator_login
  administrator_login_password = random_string.postgresql_admin_password.result
  version                      = var.pg_version
  ssl_enforcement              = var.ssl_enforcement
}
