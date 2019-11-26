variable "gp_zone" {
  type = "string"
  description = " The zone that the machines and subnet should be created in"
  default = ""
}

variable "gp_project_name" {
  type = "string"
  description = "The ID of the Google Cloud project"
  default = ""
}

variable "account_file_path" {
  type = "string"
  description = "Path to the JSON file used to describe your account credentials"
}

variable "gp_master_extra_disk_size_gb" {
 description = "The extra disk size for master node in gb "
 default=""
}

variable "gp_worker_extra_disk_size_gb" {
 description = "The extra disk size for worker node in gb"
 default=""
}

variable "ssh_source_range_ips" {
   type = "list"
   description = "IP address ranges to allow ssh for all internal nodes (bastion,master,workers)"
   default = []
}

variable disk_auto_delete {
    description = "The disk will be deleted when related instance is deleted"
	default = true
}
variable bastion_disk_size_gb {
	description = "The size of the image in gigabytes for bastion "
	default = 10
}
variable bastiondisk_type {
	description = "The GCE disk type. May be set to pd-standard or pd-ssd"
	default = "pd-ssd"
}

variable "access_config" {
  description = "The access config block for the instances. Set to [{}] for ephemeral external IP."
  type        = "list"
  default     = []
}

variable "service_account_email" {
  description = "The email of the service account for the instance template."
  default     = ""
}

variable "service_account_scopes" {
  description = "List of scopes for the instance template service account"
  type        = "list"

  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
    "https://www.googleapis.com/auth/devstorage.full_control",
  ]
}

variable "gp_master_image" {
  type = "string"
  description = "The image to use for the master nodes"
  default = ""
}

variable "gp_worker_image" {
  type = "string"
  description = "The image to use for the worker nodes"
  default = ""
}

variable "gp_bastion_image" {
  type = "string"
  description = "The image to use for the bastion node"
  default = ""
}

variable "gp_region" {
  type = "string"
  description = "The region used to deploy the cluster"
  default = ""
}

variable "gp_vpc_cidr" {
  type = "string"
  description = "The CIDR block for the VPC"
  default = ""
}

variable "gp_cluster_ssh_user" {
  type = "string"
  description = "The user that can ssh into the cluster instances (master and workers)"
  default = ""
}

variable "gp_bastion_ssh_user" {
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
