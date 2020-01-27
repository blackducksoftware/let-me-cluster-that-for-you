output "master-url" {
  value = "${module.eks.cluster_endpoint}"
}

output "cluster-auth-config" {
  value = "${module.eks.config_map_aws_auth}"
}

output "cluster-config" {
  value = "${module.eks.kubeconfig}"
}

output "master-public-dns" {
  value = [""]
}
output "master-public-ips" {
  value = [""]
}
output "master-private-dns" {
  value = [""]
}
output "master-private-ips" {
  value = [""]
}
output "master-extra-disk" {
  value = ""
}

// Worker instances information
output "worker-public-dns" {
  value = [""]
}
output "worker-public-ips" {
  value = [""]
}
output "worker-private-dns" {
  value = [""]
}
output "worker-private-ips" {
  value = [""]
}
output "worker-extra-disk" {
  value = ""
}

// Bastion instance information
output "bastion-public-dns" {
  value = [""]
}
output "bastion-public-ip" {
  value = [""]
}
output "bastion-private-dns" {
  value = [""]
}
output "bastion-private-ip" {
  value = [""]
}

output "bastion-ssh-username" {
  value = ""
}
output "cluster-ssh-username" {
  value = "ec2-user"
} 

output "additional-modules" {
  value = []
}

output "worker_node_security_group_id" {
  value = "${module.eks.worker_security_group_id}"
}
