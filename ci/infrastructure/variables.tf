// Common variables

// These variables must be provided by the user
variable "cluster_provider" {
  type = "string"
  description = "The name of the provider where the cluster will be deployed"
}

variable "cluster_prefix" {
  type = "string"
  description = "A string that will be prefixed to all resources created"
}

variable "cluster_project_name" {
  type = "string"
  description = "The project name where instances to be installed"
  default=""
}

variable "cluster_account_file_path" {
  type = "string"
  description = "Path to the JSON file used to describe your account credentials"
  default = ""
}

variable "cluster_master_extra_disk_size_gb" {
 description = "The extra disk size for master node in gb"
 default=""
}

variable "cluster_worker_extra_disk_size_gb" {
 description = "The extra disk size for worker node in gb"
 default=""
}

variable "cluster_ssh_source_range_ips" {
   type = "list"
   description = "IP address ranges to allow ssh for all internal nodes (bastion,master,workers)"
   default = []
}

variable "cluster_manager" {
  type = "string"
  description = "The name of the cluster manager to install"
  default = ""
}

variable "cluster_docker_version" {
  type = "string"
  description = "The version of docker to install.  An empty value or 'os' will install version available in distribution repos"
  default = "os"
}


// These variables are optional
variable "cluster_manager_version" {
  type = "string"
  description = "The version of the cluster manager to install.  This is needed for all cluster managers execpt those that use only docker (swarm, compose, etc)"
  default = ""
}

variable "cluster_masters" {
  type = "string"
  description = "The number of master instances to create in the cluster"
  default = "1"
}

variable "cluster_workers" {
  type = "string"
  description = "The number of worker instances to create in the cluster"
  default = "2"
}

variable "cluster_master_image" {
  type = "string"
  description = "The image to use for the master nodes"
  default = ""
}

variable "cluster_worker_image" {
  type = "string"
  description = "The image to use for the worker nodes"
  default = ""
}

variable "cluster_bastion_image" {
  type = "string"
  description = "The image to use for the bastion node"
  default = ""
}

variable "cluster_region" {
  type = "string"
  description = "The region used to deploy the cluster"
  default = ""
}

variable "cluster_vpc_cidr" {
  type = "string"
  description = "The CIDR block for the VPC"
  default = "10.10.0.0/16"
}

# Enabling for GCP
variable "cluster_zone" {
  description = " The zone that the machines and subnet should be created in"
  type = "string"
  default = ""
}


variable "cluster_key_name" {
  type = "string"
  description = "The name of the key to use for ssh access"
  default = ""
}

variable "cluster_public_key_path" {
  type = "string"
  description = "The file containing the public key to use when creating the cluster"
  default = "~/.ssh/id_rsa.pub"
}

variable "cluster_private_key_path" {
  type = "string"
  description = "The file containing the private key to use when creating the cluster"
  default = "~/.ssh/id_rsa"
}

variable "cluster_ssh_user" {
  type = "string"
  description = "The user with ssh access to the master image"
  default = ""
}

variable "cluster_ssh_user_password" {
  type = "string"
  description = "The password for the user with ssh access to the master image.  This is only used to setup key-based ssh access if the instances need it.  Currently, this is known to be needed on vSphere vms"
  default = ""
}

variable "cluster_bastion_ssh_user" {
  type = "string"
  description = "The user with ssh access to the bastion image"
  default = ""
}

variable "cluster_bastion_ssh_user_password" {
  type = "string"
  description = "The password for the user with ssh access to the bastion image.  This is only used to setup key-based ssh access if the instances need it.  Currently, this is known to be needed on vSphere vms"
  default = ""
}

variable "cluster_instance_create_timeout_minutes" {
  type = "string"
  description = "How long to wait for an instance creation before determining failure"
  default = "15"
}

variable "cluster_min_free_space_gb" {
  type = "string"
  description = "The minimun free space to install the cluster.  This will be passed to the cluster installer if the cluster installer supports it"
  default = ""
}


// AWS specific variables


// vSphere specific variables
variable "cluster_provider_user" {
  type = "string"
  description = "The username to use when accessing the cluster provider"
  default = ""
}

variable "cluster_provider_password" {
  type = "string"
  description = "The password to use when accessing the cluster provider"
  default = ""
}

variable "cluster_provider_server" {
  type = "string"
  description = "The hostname/ip of the provider server"
  default = ""
}

variable "cluster_provider_resource_pool" {
  type = "string"
  description = "The name of the vSphere resource pool"
  default = ""
}

variable "cluster_provider_network" {
  type = "string"
  description = "The name of the vSphere network"
  default = ""
}

variable "cluster_provider_datacenter" {
  type = "string"
  description = "The name of the vSphere datacenter"
  default = ""
}

variable "cluster_provider_datastore" {
  type = "string"
  description = "The name of the vSphere datastore"
  default = ""
}

variable "cluster_bastion_cpus" {
  type = "string"
  description = "The number of cpus to give the bastion instance"
  default = ""
}

variable "cluster_master_cpus" {
  type = "string"
  description = "The number of cpus to give each master instance"
  default = ""
}

variable "cluster_worker_cpus" {
  type = "string"
  description = "The number of cpus to give each worker instance"
  default = ""
}

variable "cluster_bastion_memory_megs" {
  type = "string"
  description = "The amount of memory in megabytes to give the bastion instance"
  default = ""
}

variable "cluster_master_memory_megs" {
  type = "string"
  description = "The amount of memory in megabytes to give each master instance"
  default = ""
}

variable "cluster_worker_memory_megs" {
  type = "string"
  description = "The amount of memory in megabytes to give each worker instance"
  default = ""
}

variable "cluster_domain_name" {
  type = "string"
  description = "The domain name to use for private dns names"
  default = "opssight.internal"
}
