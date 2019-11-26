output "master-url" {
  value = "${var.is_enabled == "true" ? "${var.master_public_dns_names[0]}" : ""}"
}
output "cluster-config" {
  value = ""
}
