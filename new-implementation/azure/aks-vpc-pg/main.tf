module "aks-with-vpc" {
  source = "../backends/aks-by-terraform-providers"
  prefix             = var.prefix
  location           = var.location
  kubernetes_version = var.kubernetes_version 
  workers_count      = var.workers_count
  workers_type       = var.workers_type
  aks_client_id      = var.aks_client_id
  aks_client_secret  = var.aks_client_secret
}

module "db-on-vpc" {
  source = "../backends/azure-db"
  rg_name = module.aks-with-vpc.rg_name
  location = var.location
  pg_server_name = "pg-server-name"
}

resource "azurerm_postgresql_virtual_network_rule" "pg_vnet_rule" {
  name                                 = "pg-vnet-rule"
  resource_group_name                  = module.aks-with-vpc.rg_name
  server_name                          = module.db-on-vpc.pg_server_name
  subnet_id                            = module.aks-with-vpc.subnet_id
  #ignore_missing_vnet_service_endpoint = true
}

