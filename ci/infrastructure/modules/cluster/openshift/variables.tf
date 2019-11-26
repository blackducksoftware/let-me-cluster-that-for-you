variable "master_public_dns_names" {
  type = "list"
}

variable "public_hostname" {
  type = "string"
  description = "The public hostname to use for openshift services"
}

variable "default_subdomain" {
  type = "string"
  description = "The default subdomain to use for exposed routes"
}

variable "lb_private_dns_name" {
  type = "list"
  default = []
}

variable "ssh_private_key_file" {
  type = "string"
}

variable "worker_public_dns_names" {
  type = "list"
}

variable "install_host" {
  type = "string"
  description = "The publically available hostname or IP to the host that will perform the installation"
}

variable "is_enabled" {
  type = "string"
  description = "Whether openshift should be installed"
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

variable "os_version" {
  type = "string"
  description = "The version of openshift to install"
}

variable "master_private_dns_names" {
  type = "list"
  description = "The DNS names to use as master names when installing openshift"
}

variable "worker_private_dns_names" {
  type = "list"
  description = "The DNS names to use as worker names when installing openshift"
}

variable "cluster_type" {
  type = "string"
  description = "Which varient of openshift to install.  Valid values are origin and ose"
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

variable "minimum_free_space_gb" {
  type = "string"
  description = "The minimum free space required to install openshift that is passed to the installer"
  default = ""
}
