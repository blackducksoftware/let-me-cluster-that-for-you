variable "master_nodes" {
  type = "list"
  description = "The list of master nodes that will have docker installed on them"
}

variable "worker_nodes" {
  type = "list"
  description = "The list of worker nodes that will have docker installed on them"
}

variable "master_count" {
  type = "string"
  description = "The number of master nodes that will have docker installed on them"
}

variable "worker_count" {
  type = "string"
  description = "The number of worker nodes that will have docker installed on them"
}

variable "ssh_user" {
  type = "string"
  description = "The user that can ssh to the nodes.  This user must have passwordless sudo access"
}

variable "private_key_file" {
  type = "string"
  description = "The file that contains the private key to use for ssh access to the nodes"
}

variable "docker_version" {
  type = "string"
  description = "The version of docker to install on the nodes"
  default = ""
}

variable "master_docker_disk" {
  type = "string"
  description = "The disk to use for docker's storage on the master nodes.  If this is not provided then default docker storage is used"
  default = ""
}

variable "worker_docker_disk" {
  type = "string"
  description = "The disk to use for docker's storage on the worker nodes.  If this is not provided then default docker storage is used"
  default = ""
}

variable "is_enabled" {
  type = "string"
  description = "Whether docker should be installed"
  default = "true"
}
