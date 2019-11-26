variable "az_master_image" {
  type = "string"
  description = "The image to use for the master nodes"
  default = ""
}

variable "az_worker_image" {
  type = "string"
  description = "The image to use for the worker nodes"
  default = ""
}

variable "az_bastion_image" {
  type = "string"
  description = "The image to use for the bastion node"
  default = ""
}

variable "az_region" {
  type = "string"
  description = "The region used to deploy the cluster"
  default = ""
}

variable "az_vpc_cidr" {
  type = "string"
  description = "The CIDR block for the VPC"
  default = ""
}

/*
variable "cluster_zone" {
  description = "The AZ for the public subnet, e.g: us-east-1a"
  type = "map"
}
*/

variable "az_cluster_ssh_user" {
  type = "string"
  description = "The user that can ssh into the cluster instances (master and workers)"
  default = ""
}

variable "az_bastion_ssh_user" {
  type = "string"
  description = "The user that can ssh into the bastion instance"
  default = ""
}

variable "key_name" {
  type = "string"
  description = "The name of the key to use for ssh access"
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
