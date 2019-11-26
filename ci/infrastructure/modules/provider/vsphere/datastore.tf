data "vsphere_datastore" "datastore" {
  name          = "${local.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
