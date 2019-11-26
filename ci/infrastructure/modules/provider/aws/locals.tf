locals {
  masterimagesize = "${length(var.az_master_image) > 0 ? "${var.az_master_image}" : "m4.xlarge"}"
  workerimagesize = "${length(var.az_worker_image) > 0 ? "${var.az_worker_image}" : "t2.large"}"
  bastion_image_size = "${length(var.az_bastion_image) > 0 ? "${var.az_bastion_image}" : "t2.micro"}"
  aws_region =  "${length(var.az_region) > 0 ? "${var.az_region}" : "us-east-1"}"
  vpc_cidr = "${length(var.az_vpc_cidr) > 0 ? "${var.az_vpc_cidr}" : "10.0.0.0/16"}"
  subnet_cidr = "${cidrsubnet(local.vpc_cidr, 8, 1)}"
  master_cluster_dns_names = "${data.template_file.master-cluster-dns-names.*.rendered}"
  worker_cluster_dns_names = "${data.template_file.worker-cluster-dns-names.*.rendered}"
  cluster_ssh_user = "${length(var.az_cluster_ssh_user) > 0 ? "${var.az_cluster_ssh_user}" : "ec2-user"}"
  bastion_ssh_user = "${length(var.az_bastion_ssh_user) > 0 ? "${var.az_bastion_ssh_user}" : "ec2-user"}"
}

data "template_file" "master-cluster-dns-names" {
  count = "${var.masters}"
  template = "master${count.index}.${var.prefix}.cluster"
}

data "template_file" "worker-cluster-dns-names" {
  count = "${var.workers}"
  template = "worker${count.index}.${var.prefix}.cluster"
}

/*
variable "cluster_zone" {
  description = "The AZ for the public subnet, e.g: us-east-1a"
  type = "map"
}
*/
