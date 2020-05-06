terraform {
  backend "gcs" {}
}
locals {
  random_prefix = "${var.prefix}-${random_id.tf-k8s-acc.hex}"
}
resource "random_id" "tf-k8s-acc" {
  byte_length = 3
}

provider "azurerm" {
  version = "~>1.44"
}

resource "azurerm_resource_group" "tf-k8s-acc" {
  name     = "${local.random_prefix}-rsg"
  location = var.location
}

resource "azurerm_route_table" "tf-k8s-acc" {
  name                = "${local.random_prefix}-rt"
  location            = azurerm_resource_group.tf-k8s-acc.location
  resource_group_name = azurerm_resource_group.tf-k8s-acc.name
  route {
    name                   = "default"
    address_prefix         = "10.100.0.0/14"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.1.1"
  }
}

resource "azurerm_virtual_network" "tf-k8s-acc" {
  name                = "${local.random_prefix}-network"
  location            = azurerm_resource_group.tf-k8s-acc.location
  resource_group_name = azurerm_resource_group.tf-k8s-acc.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "tf-k8s-acc" {
  name                 = "${local.random_prefix}-internal"
  resource_group_name  = azurerm_resource_group.tf-k8s-acc.name
  address_prefix       = "10.1.0.0/24"
  virtual_network_name = azurerm_virtual_network.tf-k8s-acc.name
  # this field is deprecated and will be removed in 2.0 - but is required until then
  route_table_id    = azurerm_route_table.tf-k8s-acc.id
  service_endpoints = ["Microsoft.Sql"]
}

resource "azurerm_subnet_route_table_association" "tf-k8s-acc" {
  subnet_id      = azurerm_subnet.tf-k8s-acc.id
  route_table_id = azurerm_route_table.tf-k8s-acc.id
}

