// Master instances information
output "master-public-dns" {
  value = "${vsphere_virtual_machine.masters.*.default_ip_address}"
}
output "master-public-ips" {
  value = "${vsphere_virtual_machine.masters.*.default_ip_address}"
}
output "master-private-dns" {
#  value = "${vsphere_virtual_machine.masters.*.default_ip_address}"
  value = "${local.master_names}"
}
output "master-private-ips" {
  value = "${vsphere_virtual_machine.masters.*.default_ip_address}"
}
output "master-extra-disk" {
  value = "${var.is_enabled == "true" ? "/dev/sdb" : ""}"
}

// Worker instances information
output "worker-public-dns" {
  value = "${vsphere_virtual_machine.workers.*.default_ip_address}"
}
output "worker-public-ips" {
  value = "${vsphere_virtual_machine.workers.*.default_ip_address}"
}
output "worker-private-dns" {
#  value = "${vsphere_virtual_machine.workers.*.default_ip_address}"
  value = "${local.worker_names}"
}
output "worker-private-ips" {
  value = "${vsphere_virtual_machine.workers.*.default_ip_address}"
}
output "worker-extra-disk" {
  value = "${var.is_enabled == "true" ? "/dev/sdb" : ""}"
}

// Bastion instance information
output "bastion-public-dns" {
  value = "${vsphere_virtual_machine.bastion.*.default_ip_address}"
}
output "bastion-public-ip" {
  value = "${vsphere_virtual_machine.bastion.*.default_ip_address}"
}
output "bastion-private-dns" {
  value = "${vsphere_virtual_machine.bastion.*.default_ip_address}"
}
output "bastion-private-ip" {
  value = "${vsphere_virtual_machine.bastion.*.default_ip_address}"
}

output "bastion-ssh-username" {
  value = "${var.is_enabled == "true" ? local.bastion_ssh_user : ""}"
}
output "cluster-ssh-username" {
  value = "${var.is_enabled == "true" ? local.cluster_ssh_user : ""}"
}

output "master-url" {
  value = ""
}
output "cluster-config" {
  value = ""
}
output "cluster-auth-config" {
  value = ""
}

output "additional-modules" {
  value = ["docker", "cluster"]
}
