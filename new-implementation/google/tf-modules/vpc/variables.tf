variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

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
