output "master-url" {
  value = "${module.eks.cluster_endpoint}"
}

output "cluster-auth-config" {
  value = "${module.eks.config_map_aws_auth}"
  #  value = "${var.is_enabled == "true" ? module.eks.0.config_map_aws_auth : ""}"
}

output "cluster-config" {
  value = "${module.eks.kubeconfig}"
  #  value = "${element(concat(module.eks.kubeconfig, list("")), 0)}"
  #  value = "${var.is_enabled == "true" ? module.eks.0.kubeconfig : ""}"
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

// vpc output
output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_cidr_ip" {
  value = "${module.vpc.vpc_cidr_block}"
}

output "vpc_public_subnets" {
  value = "${module.vpc.public_subnets}"
}

output "vpc_database_subnets" {
  value = "${module.vpc.database_subnets}"
}

output "worker_node_security_group_id" {
  value = "${module.eks.worker_security_group_id}"
}
