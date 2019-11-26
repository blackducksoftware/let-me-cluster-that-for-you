// Master instances information
output "master-public-dns" {
  value = "${module.cloud.master-public-dns}"
}
output "master-public-ips" {
  value = "${module.cloud.master-public-ips}"
}
output "master-private-dns" {
  value = "${module.cloud.master-private-dns}"
}
output "master-private-ips" {
  value = "${module.cloud.master-private-ips}"
}
output "master-extra-disk" {
  value = "${module.cloud.master-extra-disk}"
}

// Worker instances information
output "worker-public-dns" {
  value = "${module.cloud.worker-public-dns}"
}
output "worker-public-ips" {
  value = "${module.cloud.worker-public-ips}"
}
output "worker-private-dns" {
  value = "${module.cloud.worker-private-dns}"
}
output "worker-private-ips" {
  value = "${module.cloud.worker-private-ips}"
}
output "worker-extra-disk" {
  value = "${module.cloud.worker-extra-disk}"
}

// Bastion instance information
output "bastion-public-dns" {
  value = "${element(module.cloud.bastion-public-dns, 0)}"
}
output "bastion-public-ip" {
  value = "${element(module.cloud.bastion-public-ip, 0)}"
}
output "bastion-private-dns" {
  value = "${element(module.cloud.bastion-private-dns, 0)}"
}
output "bastion-private-ip" {
  value = "${element(module.cloud.bastion-private-ip, 0)}"
}

output "cluster-ssh-user" {
  value = "${module.cloud.cluster-ssh-username}"
}
output "bastion-ssh-user" {
  value = "${module.cloud.bastion-ssh-username}"
}

output "master-url" {
  value = "${module.cloud.master-url}"
}
output "cluster-config" {
  value = "${module.cloud.cluster-config}"
}
output "cluster-auth-config" {
  value = "${module.cloud.cluster-auth-config}"
}

output "additional-modules" {
  value = "${module.cloud.additional-modules}"
}
