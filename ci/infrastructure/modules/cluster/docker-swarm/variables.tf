variable "master_public_dns_names" {
  type = "list"
}

variable "ssh_private_key_file" {
  type = "string"
}


variable "worker_public_dns_names" {
  type = "list"
}

variable "install_host_public_dns_name" {
  type = "string"
  description = "The publically available hostname or IP for the host that will perform the installation"
}

variable "install_host_private_dns_name" {
  type = "string"
  description = "The private DNS name of the host that will perform the installation"
}

variable "is_enabled" {
  type = "string"
  description = "Whether docker swarm should be installed"
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

/* We use whatever version of docker is supplied by the OS
variable "kube_version" {
  type = "string"
  description = "The version of docker to install"
}
*/

variable "master_private_dns_names" {
  type = "list"
  description = "The DNS names to use as master names when creating the docker swarm"
}

variable "worker_private_dns_names" {
  type = "list"
  description = "The DNS names to use as worker names when creating the docker swarm"
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
