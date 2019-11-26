variable "az_worker_image" {
  type = "string"
  description = "The image to use for the worker nodes"
  default = ""
}

variable "eks_version" {
  type = "string"
  description = "The version of EKS to setup"
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

variable "prefix" {
  type = "string"
  description = "The prefix to prepend to all resources"
}

variable "workers" {
  type = "string"
  description = "The number of worker nodes create in the cluster"
}

variable "is_enabled" {
  type = "string"
  description = "Whether and EKS cluster should be created"
  default = "false"
}

variable "instance_create_timeout" {
  type = "string"
  description = "The timeout to use when creating instances"
}

variable "key_name" {
  type = "string"
  description = "The name of the key to use for ssh access"
}

variable "public_key_path" {
  type = "string"
  description = "The path to a local public key file that will be injected to the instances"
}
