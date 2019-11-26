module "openshift_origin" {
  source = "./openshift"
  is_enabled = "${var.is_enabled && var.cluster_manager_name == "origin" ? "true" : "false"}"
  depends_on = "${var.cluster_depends_on}"
  cluster_type = "origin"
  master_node_count = "${var.cluster_master_count}"
  worker_node_count = "${var.cluster_worker_count}"
  os_version = "${var.cluster_version}"
  public_hostname = "${var.cluster_public_hostname}"
  default_subdomain = "${var.cluster_subdomain}"

  cluster_ssh_user = "${var.cluster_ssh_user}"
  installer_ssh_user = "${var.cluster_installer_ssh_user}"
  ssh_private_key_file = "${var.cluster_private_key_file}"

  install_host = "${var.cluster_install_node_public_name}"

  master_public_dns_names = "${var.cluster_master_public_names}"
  worker_public_dns_names = "${var.cluster_worker_public_names}"

  master_private_dns_names = "${var.cluster_master_private_names}"
  worker_private_dns_names = "${var.cluster_worker_private_names}"

  minimum_free_space_gb = "${var.cluster_min_free_disk_gb}"
}

module "kubernetes" {
  source = "./kubernetes"
  is_enabled = "${var.is_enabled && var.cluster_manager_name == "kube" ? "true" : "false"}"
  depends_on = "${var.cluster_depends_on}"
  master_node_count = "${var.cluster_master_count}"
  worker_node_count = "${var.cluster_worker_count}"
  kube_version = "${var.cluster_version}"

  cluster_ssh_user = "${var.cluster_ssh_user}"
  installer_ssh_user = "${var.cluster_ssh_user}"
  ssh_private_key_file = "${var.cluster_private_key_file}"

  install_host_public_dns_name = "${var.cluster_master_public_ips[0]}"
  install_host_private_dns_name = "${var.cluster_master_private_ips[0]}"

  master_public_dns_names = "${var.cluster_master_public_names}"
  worker_public_dns_names = "${var.cluster_worker_public_names}"
  master_public_ips = "${var.cluster_master_public_ips}"
  worker_public_ips = "${var.cluster_worker_public_ips}"

  master_private_dns_names = "${var.cluster_master_private_names}"
  worker_private_dns_names = "${var.cluster_worker_private_names}"
  master_private_ips = "${var.cluster_master_private_ips}"
  worker_private_ips = "${var.cluster_worker_private_ips}"
}

module "docker-swarm" {
  source = "./docker-swarm"
  is_enabled = "${var.is_enabled && var.cluster_manager_name == "swarm" ? "true" : "false"}"
  depends_on = "${var.cluster_depends_on}"
  master_node_count = "${var.cluster_master_count}"
  worker_node_count = "${var.cluster_worker_count}"

  cluster_ssh_user = "${var.cluster_ssh_user}"
  installer_ssh_user = "${var.cluster_ssh_user}"
  ssh_private_key_file = "${var.cluster_private_key_file}"

  install_host_public_dns_name = "${var.cluster_master_public_names[0]}"
  install_host_private_dns_name = "${var.cluster_master_private_names[0]}"

  master_public_dns_names = "${var.cluster_master_public_names}"
  worker_public_dns_names = "${var.cluster_worker_public_names}"

  master_private_dns_names = "${var.cluster_master_private_names}"
  worker_private_dns_names = "${var.cluster_worker_private_names}"
}
