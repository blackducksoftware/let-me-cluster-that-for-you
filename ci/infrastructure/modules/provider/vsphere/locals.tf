locals {
  bastion_cpus = "${length(var.bastion_cpu_count) > 0 ? "${var.bastion_cpu_count}" : "1"}"
  master_cpus = "${length(var.master_cpu_count) > 0 ? "${var.master_cpu_count}" : "4"}"
  worker_cpus = "${length(var.worker_cpu_count) > 0 ? "${var.worker_cpu_count}" : "2"}"

  bastion_memory = "${length(var.bastion_memory_megs) > 0 ? "${var.bastion_memory_megs}" : "4096"}"
  master_memory = "${length(var.master_memory_megs) > 0 ? "${var.master_memory_megs}" : "16192"}"
  worker_memory = "${length(var.worker_memory_megs) > 0 ? "${var.worker_memory_megs}" : "8192"}"

  bastion_template_name = "${length(var.bastion_template) > 0 ? "${var.bastion_template}" : "cn-centos7-template-dont-delete"}"
  master_template_name = "${length(var.master_template) > 0 ? "${var.master_template}" : "cn-centos7-template-dont-delete"}"
  worker_template_name = "${length(var.worker_template) > 0 ? "${var.worker_template}" : "cn-centos7-template-dont-delete"}"

  datacenter = "${length(var.datacenter_name) > 0 ? "${var.datacenter_name}" : "Burlington"}"
  datastore = "${length(var.datastore_name) > 0 ? "${var.datastore_name}" : "ops-vvol01"}"
  resource_pool = "${length(var.resource_pool_name) > 0 ? "${var.resource_pool_name}" : "IT-DRS"}"
  network = "${length(var.network_name) > 0 ? "${var.network_name}" : "DC1-Eng72"}"

  master_names = "${data.template_file.master-names.*.rendered}"
  worker_names = "${data.template_file.worker-names.*.rendered}"
  master_private_dns_names = "${data.template_file.master-private-dns-names.*.rendered}"
  worker_private_dns_names = "${data.template_file.worker-private-dns-names.*.rendered}"
  name_postfix = "${replace(var.prefix, "/[^A-Za-z0-9]+/", "-")}"

  cluster_ssh_user = "${length(var.cluster_ssh_user) > 0 ? "${var.cluster_ssh_user}" : "enguser"}"
  bastion_ssh_user = "${length(var.bastion_ssh_user) > 0 ? "${var.bastion_ssh_user}" : "enguser"}"
}

data "template_file" "master-names" {
  count = "${var.masters}"
  template = "master${count.index}-${local.name_postfix}"
}

data "template_file" "worker-names" {
  count = "${var.workers}"
  template = "worker${count.index}-${local.name_postfix}"
}

data "template_file" "master-private-dns-names" {
  count = "${var.masters}"
  template = "master${count.index}-${local.name_postfix}.${var.domain_name}"
}

data "template_file" "worker-private-dns-names" {
  count = "${var.workers}"
  template = "worker${count.index}-${local.name_postfix}.${var.domain_name}"
}
