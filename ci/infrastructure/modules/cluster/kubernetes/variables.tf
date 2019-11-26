variable "master_public_dns_names" {
  type = "list"
  description = "A list of publically accessible DNS names for the master nodes"
}

variable "master_public_ips" {
  type = "list"
  description = "A list of publically accessible ips for the master nodes"
}

variable "ssh_private_key_file" {
  type = "string"
}


variable "worker_public_dns_names" {
  type = "list"
  description = "A list of publically accessible DNS names for the worker nodes"
}

variable "worker_public_ips" {
  type = "list"
  description = "A list of publically accessible ips for the worker nodes"
}

variable "install_host_public_dns_name" {
  type = "string"
  description = "The publicly available hostname or IP to the host that will perform the installation"
}

variable "install_host_private_dns_name" {
  type = "string"
  description = "The private DNS name of the host that will perform the installation"
}

variable "is_enabled" {
  type = "string"
  description = "Whether kubernetes should be installed"
  default = "false"
}

variable "master_node_count" {
  type = "string"
  description = "The number of master nodes to install"
}

variable "worker_node_count" {
  type = "string"
  description = "The number of worker nodes to install"
}

variable "kube_version" {
  type = "string"
  description = "The version of kubernetes to install"
}

variable "master_private_dns_names" {
  type = "list"
  description = "The DNS names to use as master names when installing kubernetes"
}

variable "master_private_ips" {
  type = "list"
  description = "The private ips of master nodes"
}

variable "worker_private_dns_names" {
  type = "list"
  description = "The DNS names to use as worker names when installing kubernetes"
}

variable "worker_private_ips" {
  type = "list"
  description = "The private ips of worker nodes"
}

variable "cluster_ssh_user" {
  type = "string"
  description = "The user that can access the cluster instances.  This user must exist on the masters and the workers and should have passwordless sudo access"
}

variable "installer_ssh_user" {
  type = "string"
  description = "The user that can access the installer instance.  This user should have passwordless sudo access"
}

variable "depends_on" {
  type = "string"
  description = "A dependency that must complete before this module runs"
}
