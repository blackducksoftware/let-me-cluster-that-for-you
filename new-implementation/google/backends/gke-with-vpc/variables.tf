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

variable "master_authorized_networks_cidr_blocks" {
  type = list(map(string))

  default = [
    {
      cidr_block = "198.182.52.26/32"
      display_name = "Bengaluru-India"
    },
    {
      cidr_block = "149.117.0.0/16"
      display_name = "snps-1"
    },
    {
      cidr_block = "198.182.32.0/19"
      display_name = "snps-2"
    },
    {
      cidr_block = "216.85.161.194/32"
      display_name = "snps-4"
    },
    {
      cidr_block = "50.21.174.162/32"
      display_name = "Hitakshi-vpn-ip"
    },
    {
      cidr_block = "198.182.56.5/32"
      display_name = "Hitakshi-office-ip"
    },
    {
      cidr_block = "192.231.134.1/32"
      display_name = "dc2"
    },
    {
      cidr_block = "193.240.221.236/32"
      display_name = "thale-and-belfast"
    },
    {
      cidr_block = "58.76.201.220/32"
      display_name = "south-korea"
    },
    {
      cidr_block = "80.75.109.253/32"
      display_name = "fuzztds-office"
    }
  ]

}

variable "location" {
  # https://www.terraform.io/docs/providers/google/r/container_cluster.html#location
  # The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well
  description = "The region or zone to host the cluster in"
  type        = string
  default     = "us-east1-b"
}

variable "initial_node_count" {
  type        = number
  description = "The number of nodes to create in this cluster's default node pool per zone/region."
  default     = 3
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

variable "region" {
  # NOTE: make sure the region matches location variable above
  description = "The region for the subnetwork; MUST match region specified in location"
  type        = string
  default     = "us-east1"
}
