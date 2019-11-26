module "cloud" {
  source = "./vsphere"
  is_enabled = "${var.provider_name == "vsphere" ? "true" : "false"}"

  bastion_template = "${var.provider_bastion_image}"
  bastion_cpu_count = "${var.provider_bastion_cpus}"
  bastion_memory_megs = "${var.provider_bastion_memory_megs}"

  masters = "${var.provider_master_count}"
  master_template = "${var.provider_master_image}"
  master_cpu_count = "${var.provider_master_cpus}"
  master_memory_megs = "${var.provider_master_memory_megs}"

  workers = "${var.provider_worker_count}"
  worker_template = "${var.provider_worker_image}"
  worker_cpu_count = "${var.provider_worker_cpus}"
  worker_memory_megs = "${var.provider_worker_memory_megs}"

  bastion_ssh_user = "${var.provider_bastion_ssh_user}"
  bastion_ssh_user_password = "${var.provider_bastion_ssh_user_password}"
  cluster_ssh_user = "${var.provider_cluster_ssh_user}"
  cluster_ssh_user_password = "${var.provider_cluster_ssh_user_password}"
  public_key_path = "${var.provider_public_key_path}"
  private_key_path = "${var.provider_private_key_path}"

  prefix = "${var.provider_prefix}"
  instance_create_timeout = "${var.provider_instance_create_timeout}"

  user = "${var.provider_user}"
  password = "${var.provider_password}"
  server = "${var.provider_server}"
  resource_pool_name = "${var.provider_resource_pool}"
  network_name = "${var.provider_network}"
  datacenter_name = "${var.provider_datacenter}"
  datastore_name = "${var.provider_datastore}"
  domain_name = "${var.provider_domain_name}"
}
