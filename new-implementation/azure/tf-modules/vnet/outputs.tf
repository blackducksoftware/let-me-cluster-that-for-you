output "rg_name" {
  value = azurerm_resource_group.tf-k8s-acc
}

output "subnet_id" {
  value = azurerm_subnet.tf-k8s-acc.id
}
