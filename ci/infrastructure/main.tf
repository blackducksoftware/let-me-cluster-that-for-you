module "infra" {
  source = "./modules/provider"
  provider_name = "${var.cluster_provider}"
  provider_prefix = "${var.cluster_prefix}"
  
  provider_project_name = "${var.cluster_project_name}"
  provider_account_file_path = "${var.cluster_account_file_path}"
  provider_master_extra_disk_size_gb = "${var.cluster_master_extra_disk_size_gb}"
  provider_worker_extra_disk_size_gb = "${var.cluster_worker_extra_disk_size_gb}"
  provider_ssh_source_range_ips = "${var.cluster_ssh_source_range_ips}"

  provider_master_count = "${var.cluster_masters}"
  provider_master_image = "${var.cluster_master_image}"
  provider_master_cpus = "${var.cluster_master_cpus}"
  provider_master_memory_megs = "${var.cluster_master_memory_megs}"

  provider_worker_count = "${var.cluster_workers}"
  provider_worker_image = "${var.cluster_worker_image}"
  provider_worker_cpus = "${var.cluster_worker_cpus}"
  provider_worker_memory_megs = "${var.cluster_worker_memory_megs}"

  provider_bastion_image = "${var.cluster_bastion_image}"
  provider_bastion_cpus = "${var.cluster_bastion_cpus}"
  provider_bastion_memory_megs = "${var.cluster_bastion_memory_megs}"

  provider_cluster_ssh_user = "${var.cluster_ssh_user}"
  provider_cluster_ssh_user_password = "${var.cluster_ssh_user_password}"
  provider_bastion_ssh_user = "${var.cluster_bastion_ssh_user}"
  provider_bastion_ssh_user_password = "${var.cluster_bastion_ssh_user_password}"
  provider_public_key_path = "${var.cluster_public_key_path}"
  provider_private_key_path = "${var.cluster_private_key_path}"

  provider_region = "${var.cluster_region}"
  provider_zone = "${var.cluster_zone}"
  provider_vpc_cidr = "${var.cluster_vpc_cidr}"
//  zone = "${var.subnetaz}"
//  zone = "us-east-1a"

  provider_key_name = "${length(var.cluster_key_name) > 0 ? "${var.cluster_key_name}" : "${var.cluster_prefix}-cluster-keypair"}"
  provider_instance_create_timeout = "${var.cluster_instance_create_timeout_minutes}"

  provider_user = "${var.cluster_provider_user}"
  provider_password = "${var.cluster_provider_password}"
  provider_server = "${var.cluster_provider_server}"
  provider_resource_pool = "${var.cluster_provider_resource_pool}"
  provider_network = "${var.cluster_provider_network}"
  provider_datacenter = "${var.cluster_provider_datacenter}"
  provider_datastore = "${var.cluster_provider_datastore}"
  provider_domain_name = "${var.cluster_domain_name}"

  provider_cluster_version = "${var.cluster_manager_version}"
}

module "docker_installer" {
  source = "./modules/docker"

  is_enabled = "${contains(module.infra.additional-modules, "docker")}"

  # It would be so nice to be able to concatenate these values since masters and workers are treated the same in
  # this module, but alas count can not be computed:
  # https://github.com/hashicorp/terraform/issues/10857
  # https://github.com/hashicorp/terraform/issues/12570
  master_nodes = "${module.infra.master-public-dns}"
  worker_nodes = "${module.infra.worker-public-dns}"
  master_count = "${var.cluster_masters}"
  worker_count = "${var.cluster_workers}"

  master_docker_disk = "${module.infra.master-extra-disk}"
  worker_docker_disk = "${module.infra.worker-extra-disk}"

  docker_version = "${var.cluster_docker_version}"
  ssh_user = "${length(var.cluster_ssh_user) > 0 ? "${var.cluster_ssh_user}" : "${module.infra.cluster-ssh-user}"}"
  private_key_file = "${var.cluster_private_key_path}"
}

module "cluster" {
  source = "./modules/cluster"
  is_enabled = "${contains(module.infra.additional-modules, "cluster")}"
  cluster_manager_name = "${var.cluster_manager}"
  cluster_version = "${length(var.cluster_manager_version) > 0 ? "${var.cluster_manager_version}" : "${var.cluster_docker_version}"}"

  # This is silly, but needed because there isn't a way to mave modules depend on on another.  Based off of:
  # https://github.com/hashicorp/terraform/issues/1178#issuecomment-207369534
  cluster_depends_on = "${module.docker_installer.dependency-id}"

  # It would be so nice to not have to pass these values in at all and just compute the numbers in the module
  # based off the list of public_names passed in, but alas count can not be computed:
  # https://github.com/hashicorp/terraform/issues/10857
  # https://github.com/hashicorp/terraform/issues/12570
  cluster_master_count = "${var.cluster_masters}"
  cluster_worker_count = "${var.cluster_workers}"

  cluster_master_public_names = "${module.infra.master-public-dns}"
  cluster_worker_public_names = "${module.infra.worker-public-dns}"
  cluster_master_private_names = "${module.infra.master-private-dns}"
  cluster_worker_private_names = "${module.infra.worker-private-dns}"
  cluster_master_public_ips = "${module.infra.master-public-ips}"
  cluster_worker_public_ips = "${module.infra.worker-public-ips}"
  cluster_master_private_ips = "${module.infra.master-private-ips}"
  cluster_worker_private_ips = "${module.infra.worker-private-ips}"

  cluster_ssh_user = "${length(var.cluster_ssh_user) > 0 ? "${var.cluster_ssh_user}" : "${module.infra.cluster-ssh-user}"}"
  cluster_installer_ssh_user = "${length(var.cluster_bastion_ssh_user) > 0 ? "${var.cluster_bastion_ssh_user}" : "${module.infra.bastion-ssh-user}"}"

  cluster_install_node_public_name = "${module.infra.bastion-public-ip}"
  cluster_install_node_private_name = "${module.infra.bastion-private-ip}"

  cluster_public_hostname = "${module.infra.master-public-ips[0]}.xip.io"
  cluster_subdomain = "${module.infra.master-public-ips[0]}.xip.io"
  cluster_private_key_file = "${var.cluster_private_key_path}"

  cluster_min_free_disk_gb = "${var.cluster_min_free_space_gb}"
}
