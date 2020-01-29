output "kubeconfig_path" {
  value = module.aks-with-vpc.kubeconfig_path
}

output "psql_user_pass" {
  value = module.db-on-vpc.password
}