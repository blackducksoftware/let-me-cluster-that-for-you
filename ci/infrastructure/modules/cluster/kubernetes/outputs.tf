output "master-url" {
  value = "${var.is_enabled == "true" ? "https://${var.master_public_dns_names[0]}:8443" : ""}"
}
output "cluster-config" {
  value = "${var.is_enabled == "true" ? "${lookup(data.external.kubeconfig.result, "kubeconfig", "")}" : ""}"
}
