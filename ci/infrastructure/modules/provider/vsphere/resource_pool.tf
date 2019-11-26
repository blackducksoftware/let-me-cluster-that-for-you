data "vsphere_resource_pool" "pool" {
  name          = "${local.resource_pool}/Resources"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
