variable "cluster_manager_name" {
  type = "string"
  description = "The name of the cluster manager to install"
}

variable "cluster_version" {
  type = "string"
  description = "The version of the cluster manager to install"
}

variable "cluster_master_count" {
  type = "string"
  description = "The number of masters to intall"
}

variable "cluster_worker_count" {
  type = "string"
  description = "The number of workers to intall"
}

variable "cluster_private_key_file" {
  type = "string"
  description = "The private ssh key needed to access cluster nodes"
}

variable "cluster_public_hostname" {
  type = "string"
  description = "The publicly accessable hostname for accessing the cluster"
}

variable "cluster_install_node_public_name" {
  type = "string"
  description = "The publicly accessible host where the installer will be run"
}

variable "cluster_install_node_private_name" {
  type = "string"
  description = "The private DNS friendly name where the installer will be run"
}

variable "cluster_subdomain" {
  type = "string"
  description = "The default subdomain for the cluster"
}

variable "cluster_master_public_names" {
  type = "list"
  description = "A list of publically accessible master node DNS names"
}

variable "cluster_worker_public_names" {
  type = "list"
  description = "A list of publically accessible worker node DNS names"
}

variable "cluster_master_public_ips" {
  type = "list"
  description = "A list of publically accessible master node ips"
}

variable "cluster_worker_public_ips" {
  type = "list"
  description = "A list of publically accessible worker node ips"
}

variable "cluster_master_private_names" {
  type = "list"
  description = "A list of private DNS friendly names to use as master nodes when creating the cluster"
}

variable "cluster_worker_private_names" {
  type = "list"
  description = "A list of private DNS friendly names to use as worker nodes when creating the cluster"
}

variable "cluster_master_private_ips" {
  type = "list"
  description = "A list of private ips for master nodes in the cluster"
}

variable "cluster_worker_private_ips" {
  type = "list"
  description = "A list of private ips for worker nodes in the cluster"
}

variable "cluster_ssh_user" {
  type = "string"
  description = "The user that can ssh into the cluster instances"
}

variable "cluster_installer_ssh_user" {
  type = "string"
  description = "The user that can ssh into the host that will perform the installation"
}

variable "cluster_depends_on" {
  type = "string"
  description = "A value that the cluster module needs before it can run"
}

variable "cluster_min_free_disk_gb" {
  type = "string"
  description = "The minimum amount of free disk space required to install the cluster"
  default = ""
}

variable "is_enabled" {
  type = "string"
  description = "Determines if the cluster module should install a cluster manager"
  default = "true"
}
