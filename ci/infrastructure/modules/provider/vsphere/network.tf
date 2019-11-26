data "vsphere_network" "network" {
  name          = "${local.network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
