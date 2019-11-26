output "master-url" {
  value = "${var.is_enabled == "true" ? "https://${var.master_public_dns_names[0]}:8443" : ""}"
}
output "cluster-config" {
  value = "${var.is_enabled == "true" ? "oc login https://${var.master_public_dns_names[0]}:8443 -u admin -p admin" : ""}"
}
