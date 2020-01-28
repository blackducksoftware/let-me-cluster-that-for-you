resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
}

module "aks" {
  source  = "Azure/aks/azurerm"
  version = "2.0.0"

  CLIENT_ID          = var.CLIENT_ID
  CLIENT_SECRET      = var.CLIENT_SECRET
  prefix             = var.prefix
  location           = var.location
  kubernetes_version = var.kubernetes_version
}
