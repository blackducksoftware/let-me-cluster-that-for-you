locals {
  masterimagesize = "${length(var.gp_master_image) > 0 ? "${var.gp_master_image}" : "n1-standard-4"}"
  workerimagesize = "${length(var.gp_worker_image) > 0 ? "${var.gp_worker_image}" : "n1-standard-4"}"
  bastion_image_size = "${length(var.gp_bastion_image) > 0 ? "${var.gp_bastion_image}" : "g1-small"}"
  gcp_project_name = "${length(var.gp_project_name) > 0 ? "${var.gp_project_name}" : ""}"
  gcp_region =  "${length(var.gp_region) > 0 ? "${var.gp_region}" : "us-east1"}"
  gcp_zone   =  "${length(var.gp_zone) > 0 ?  "${var.gp_zone}" : "us-east1-b"}"
  vpc_cidr = "${length(var.gp_vpc_cidr) > 0 ? "${var.gp_vpc_cidr}" : "10.0.0.0/16"}"
  subnet_cidr = "${cidrsubnet(local.vpc_cidr, 8, 1)}"
  gcp_master_extra_disk_size_gb = "${length(var.gp_master_extra_disk_size_gb) > 0 ? "${var.gp_master_extra_disk_size_gb}" : "80" }"
  gcp_worker_extra_disk_size_gb = "${length(var.gp_worker_extra_disk_size_gb) > 0 ? "${var.gp_worker_extra_disk_size_gb}" : "80" }"
  master_cluster_dns_names = "${data.template_file.master-cluster-dns-names.*.rendered}"
  worker_cluster_dns_names = "${data.template_file.worker-cluster-dns-names.*.rendered}"
  cluster_ssh_user = "${length(var.gp_cluster_ssh_user) > 0 ? "${var.gp_cluster_ssh_user}" : "gcp-user"}"
  bastion_ssh_user = "${length(var.gp_bastion_ssh_user) > 0 ? "${var.gp_bastion_ssh_user}" : "gcp-user"}"
}

data "template_file" "master-cluster-dns-names" {
  count = "${var.masters}"
  template = "master${count.index}.${var.prefix}.cluster"
}

data "template_file" "worker-cluster-dns-names" {
  count = "${var.workers}"
  template = "worker${count.index}.${var.prefix}.cluster"
}
