provider "vsphere" {
  user = "${var.user}"
  password = "${var.password}"
  vsphere_server = "${var.server}"
  allow_unverified_ssl = true
}
