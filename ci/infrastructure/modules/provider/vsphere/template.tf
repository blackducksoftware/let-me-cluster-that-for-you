data "vsphere_virtual_machine" "bastion_template" {
  name = "${local.bastion_template_name}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "master_template" {
  name = "${local.master_template_name}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "worker_template" {
  name = "${local.worker_template_name}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
