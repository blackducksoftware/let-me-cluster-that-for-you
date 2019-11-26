// These variables must be provided by the caller
variable "provider_prefix" {
  type = "string"
  description = "The prefix to prepend to all resources"
}

variable "provider_project_name" {
  type = "string"
  description = "The project name where instances to be installed"
  default=""
}

variable "provider_account_file_path" {
  type = "string"
  description = "Path to the JSON file used to describe your account credentials"
  default=""
}

variable "provider_master_extra_disk_size_gb" {
 description = "The extra disk size for master node in gb"
 default=""
}

variable "provider_worker_extra_disk_size_gb" {
 description = "The extra disk size for worker node in gb"
 default=""
}

variable "provider_ssh_source_range_ips" {
   type = "list"
   description = "IP address ranges to allow ssh for all internal nodes (bastion,master,workers)"
   default = []
}

variable "provider_master_count" {
  type = "string"
  description = "The number of master nodes to deploy in the cluster"
}

variable "provider_worker_count" {
  type = "string"
  description = "The number of worker nodes to deploy in the cluster"
}

variable "provider_name" {
  type = "string"
  description = "The name of the provider where the cluster will be created"
}

variable "provider_key_name" {
  type = "string"
  description = "The name of the keypair to create in the cloud provider for ssh access"
}

variable "provider_public_key_path" {
  type = "string"
  description = "The path to a local public key file"
}

variable "provider_private_key_path" {
  type = "string"
  description = "The path to a local private key file"
}

variable "provider_instance_create_timeout" {
  type = "string"
  description = "How long to wait before determining instance creation timeout"
}


// These variables are optional 
variable "provider_master_image" {
  type = "string"
  description = "The image to use for the master nodes"
  default = ""
}

variable "provider_worker_image" {
  type = "string"
  description = "The image to use for the worker nodes"
  default = ""
}

variable "provider_bastion_image" {
  type = "string"
  description = "The image to use for the bastion node"
  default = ""
}

variable "provider_region" {
  type = "string"
  description = "The region used to deploy the cluster"
  default = ""
}

variable "provider_vpc_cidr" {
  type = "string"
  description = "The CIDR block for a VPC"
  default = ""
}

# Enabling for GCP
variable "provider_zone" {
  type = "string"
  description = " The zone that the machines and subnet should be created in"
  default = ""
}


variable "provider_cluster_ssh_user" {
  type = "string"
  description = "The user that can ssh into the cluster instances (both master and worker)"
  default = ""
}

variable "provider_cluster_ssh_user_password" {
  type = "string"
  description = "The password to the user that can ssh into the cluster instances (both master and worker)"
  default = ""
}

variable "provider_bastion_ssh_user" {
  type = "string"
  description = "The user that can ssh into the bastion instance"
  default = ""
}

variable "provider_bastion_ssh_user_password" {
  type = "string"
  description = "The password to the user that can ssh into the bastion instance"
  default = ""
}

variable "provider_user" {
  type = "string"
  description = "The username to use when accessing the cluster provider"
  default = ""
}

variable "provider_password" {
  type = "string"
  description = "The password to use when accessing the cluster provider"
  default = ""
}

variable "provider_server" {
  type = "string"
  description = "The hostname/ip of the provider server"
  default = ""
}

variable "provider_resource_pool" {
  type = "string"
  description = "The name of the vSphere resource pool"
  default = ""
}

variable "provider_network" {
  type = "string"
  description = "The name of the vSphere network"
  default = ""
}

variable "provider_datacenter" {
  type = "string"
  description = "The name of the vSphere datacenter"
  default = ""
}

variable "provider_datastore" {
  type = "string"
  description = "The name of the vSphere datastore"
  default = ""
}

variable "provider_bastion_cpus" {
  type = "string"
  description = "The number of cpus to give the bastion instance"
  default = ""
}

variable "provider_master_cpus" {
  type = "string"
  description = "The number of cpus to give each master instance"
  default = ""
}

variable "provider_worker_cpus" {
  type = "string"
  description = "The number of cpus to give each worker instance"
  default = ""
}

variable "provider_bastion_memory_megs" {
  type = "string"
  description = "The amount of memory in megabytes to give the bastion instance"
  default = ""
}

variable "provider_master_memory_megs" {
  type = "string"
  description = "The amount of memory in megabytes to give each master instance"
  default = ""
}

variable "provider_worker_memory_megs" {
  type = "string"
  description = "The amount of memory in megabytes to give each worker instance"
  default = ""
}

variable "provider_domain_name" {
  type = "string"
  description = "The domain name to use for instances"
  default = ""
}

variable "provider_cluster_version" {
  type = "string"
  description = "The version of cluster manager the provider should install if the providers supports it"
  default = ""
}
