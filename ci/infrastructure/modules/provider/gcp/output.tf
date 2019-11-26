output "master-public-ips" {
 value = "${google_compute_instance.master.*.network_interface.0.access_config.0.nat_ip}"
}
output "master-private-ips" {
 value = "${google_compute_instance.master.*.network_interface.0.network_ip}"
}

output "master-public-dns" {
  value = "${google_compute_instance.master.*.network_interface.0.access_config.0.nat_ip}"
}

output "master-private-dns" {
  value = "${google_compute_instance.master.*.network_interface.0.network_ip}"
}

output "master-extra-disk" {
  value = "${var.is_enabled == "true" ? "/dev/sdb" : ""}"
}


output "worker-public-ips" {
 value = "${google_compute_instance.worker.*.network_interface.0.access_config.0.nat_ip}"
}
output "worker-private-ips" {
 value = "${google_compute_instance.worker.*.network_interface.0.network_ip}"
}
output "worker-public-dns" {
  value = "${google_compute_instance.worker.*.network_interface.0.access_config.0.nat_ip}"
}
output "worker-private-dns" {
  value = "${google_compute_instance.worker.*.network_interface.0.network_ip}"
}
output "worker-extra-disk" {
  value = "${var.is_enabled == "true" ? "/dev/sdb" : ""}"
}


// Bastion instance information
output "bastion-public-dns" {
  value = ["${google_compute_instance.bastion.*.network_interface.0.access_config.0.nat_ip}"]
}
output "bastion-private-dns" {
  value = ["${google_compute_instance.bastion.*.network_interface.0.network_ip}"]
}
output "bastion-ssh-username" {
  value = "${var.is_enabled == "true" ? local.bastion_ssh_user : ""}"
}
output "cluster-ssh-username" {
  value = "${var.is_enabled == "true" ? local.cluster_ssh_user : ""}"
}

output "bastion-public-ip" {
 value = "${google_compute_instance.bastion.*.network_interface.0.access_config.0.nat_ip}"
}
output "bastion-private-ip" {
 value = "${google_compute_instance.bastion.*.network_interface.0.network_ip}"
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
