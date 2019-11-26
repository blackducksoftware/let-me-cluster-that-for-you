// Master instances information
output "master-public-dns" {
  value = "${aws_instance.masters.*.public_dns}"
}
output "master-public-ips" {
  value = "${aws_instance.masters.*.public_ip}"
}
output "master-private-dns" {
  value = "${aws_instance.masters.*.private_dns}"
}
output "master-private-ips" {
  value = "${aws_instance.masters.*.private_ip}"
}
output "master-extra-disk" {
  value = "${var.is_enabled == "true" ? "/dev/xvdf" : ""}"
}

// Worker instances information
output "worker-public-dns" {
  value = "${aws_instance.workers.*.public_dns}"
}
output "worker-public-ips" {
  value = "${aws_instance.workers.*.public_ip}"
}
output "worker-private-dns" {
  value = "${aws_instance.workers.*.private_dns}"
}
output "worker-private-ips" {
  value = "${aws_instance.workers.*.private_ip}"
}
output "worker-extra-disk" {
  value = "${var.is_enabled == "true" ? "/dev/xvdf" : ""}"
}

// Bastion instance information
output "bastion-public-dns" {
  value = "${aws_instance.bastion.*.public_dns}"
}
output "bastion-public-ip" {
  value = "${aws_instance.bastion.*.public_ip}"
}
output "bastion-private-dns" {
  value = "${aws_instance.bastion.*.private_dns}"
}
output "bastion-private-ip" {
  value = "${aws_instance.bastion.*.private_ip}"
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
