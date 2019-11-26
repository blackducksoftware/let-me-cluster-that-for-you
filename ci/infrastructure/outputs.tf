output "master-public-dns" {
  value = "${module.infra.master-public-dns}"
}
output "master-public-ips" {
  value = "${module.infra.master-public-ips}"
}

output "worker-public-dns" {
  value = "${module.infra.worker-public-dns}"
}
output "worker-public-ips" {
  value = "${module.infra.worker-public-ips}"
}

output "bastion-public-dns" {
  value = "${module.infra.bastion-public-dns}"
}
output "bastion-public-ip" {
  value = "${module.infra.bastion-public-ip}"
}

output "cluster-master-url" {
  value = "${coalesce(module.infra.master-url, module.cluster.master-url)}"
}

output "cluster-ssh-user" {
  value = "${module.infra.cluster-ssh-user}"
}

output "cluster-ssh-key" {
  value = "${var.cluster_private_key_path}"
}

output "cluster-config" {
  value = "${coalesce(module.infra.cluster-config, module.cluster.cluster-config)}"
}

output "cluster-auth-config" {
  value = "${coalesce(module.infra.cluster-auth-config, module.cluster.cluster-auth-config)}"
}
