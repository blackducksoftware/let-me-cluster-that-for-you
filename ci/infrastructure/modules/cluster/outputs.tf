output "master-url" {
  value = "${coalesce(module.openshift_origin.master-url, module.kubernetes.master-url, module.docker-swarm.master-url)}"
}
output "cluster-config" {
  value = "${coalesce(module.openshift_origin.cluster-config, module.kubernetes.cluster-config, module.docker-swarm.cluster-config)}"
}
output "cluster-auth-config" {
  value = ""
}
