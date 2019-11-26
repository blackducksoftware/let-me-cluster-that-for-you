variable "user" {
  type = "string"
  description = "The username to use when accessing the vSphere server"
}

variable "password" {
  type = "string"
  description = "The password to use when accessing the vSphere server"
}

variable "server" {
  type = "string"
  description = "The hostname/ip of the vSphere server"
}

variable "resource_pool_name" {
  type = "string"
  description = "The name of the vSphere resource pool"
}

variable "network_name" {
  type = "string"
  description = "The name of the vSphere network"
}

variable "datacenter_name" {
  type = "string"
  description = "The name of the vSphere datacenter"
}

variable "datastore_name" {
  type = "string"
  description = "The name of the vSphere datastore"
}

variable "cluster_ssh_user" {
  type = "string"
  description = "The user that can ssh into the cluster instances (master and workers)"
}

variable "cluster_ssh_user_password" {
  type = "string"
  description = "The password for the user that can ssh into the cluster instances (master and workers).  This is used to setup passwordless ssh"
}

variable "bastion_ssh_user" {
  type = "string"
  description = "The user that can ssh into the bastion instance"
}

variable "bastion_ssh_user_password" {
  type = "string"
  description = "The password for the user that can ssh into the bastion instance.  This is used to setup passwordless ssh"
}

variable "public_key_path" {
  type = "string"
  description = "The path to a local public key file that will be injected to the instances"
}

variable "private_key_path" {
  type = "string"
  description = "The path to a local private key file that matches the public_key_path"
}

variable "prefix" {
  type = "string"
  description = "The prefix to prepend to all resources"
}

variable "masters" {
  type = "string"
  description = "The number of master nodes to deploy in the cluster"
}

variable "workers" {
  type = "string"
  description = "The number of worker nodes to deploy in the cluster"
}

variable "is_enabled" {
  type = "string"
  description = "Whether to AWS provider is enabled"
  default = "false"
}

variable "instance_create_timeout" {
  type = "string"
  description = "The timeout to use when creating instances"
}

variable "master_template" {
  type = "string"
  description = "The template to use for the master nodes"
  default = ""
}

variable "worker_template" {
  type = "string"
  description = "The template to use for the worker nodes"
  default = ""
}

variable "bastion_template" {
  type = "string"
  description = "The template to use for the bastion node"
  default = ""
}

variable "bastion_cpu_count" {
  type = "string"
  description = "The number of cpus to give the bastion instance"
  default = ""
}

variable "master_cpu_count" {
  type = "string"
  description = "The number of cpus to give each master instance"
  default = ""
}

variable "worker_cpu_count" {
  type = "string"
  description = "The number of cpus to give each worker instance"
  default = ""
}

variable "bastion_memory_megs" {
  type = "string"
  description = "The amount of memory in megabytes to give the bastion instance"
  default = ""
}

variable "master_memory_megs" {
  type = "string"
  description = "The amount of memory in megabytes to give each master instance"
  default = ""
}

variable "worker_memory_megs" {
  type = "string"
  description = "The amount of memory in megabytes to give each worker instance"
  default = ""
}

variable "domain_name" {
  type = "string"
  description = "The domain name to use for private dns entries"
  default = ""
}
