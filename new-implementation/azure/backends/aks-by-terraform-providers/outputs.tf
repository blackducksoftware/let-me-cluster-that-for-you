output "kubeconfig_path" {
  value = local_file.kubeconfig.filename
}

output "rg_name" {
  value = azurerm_resource_group.tf-k8s-acc.name

}
