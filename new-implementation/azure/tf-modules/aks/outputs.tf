output "kubeconfig_path" {
  value = local_file.kubeconfig.filename
}
output "kube_config" {
  value = "${azurerm_kubernetes_cluster.tf-k8s-acc.kube_config_raw}"
}