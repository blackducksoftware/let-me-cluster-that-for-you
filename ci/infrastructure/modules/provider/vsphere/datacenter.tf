data "vsphere_datacenter" "dc" {
  name = "${local.datacenter}"
}
