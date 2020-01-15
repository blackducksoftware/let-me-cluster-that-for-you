variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "cluster_name" {
  description = "The name for the GKE cluster"
  type        = string
  default     = "gke-on-vpc-cluster"
}

variable "kubernetes_version" {
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region."
  type        = string
  default     = "latest"
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
  default     = "us-east1"
}

variable "initial_node_count" {
  type        = number
  description = "The number of nodes to create in this cluster's default node pool per zone/region."
  default     = 1
}

variable "machine_type" {
  # https://cloud.google.com/compute/docs/reference/rest/v1/instances#machineType
  type        = string
  description = "The name of a Google Compute Engine machine type."
  default     = "n1-standard-4"
}

##########
variable "network_name" {
  description = "The VPC network created to host the cluster in"
  type        = string
  default     = "gke-network"
}

variable "subnet_name" {
  description = "The subnetwork created to host the cluster in"
  type        = string
  default     = "gke-subnet"
}
