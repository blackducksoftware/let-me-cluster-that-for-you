variable "prefix" {
  description = "A prefix used for all resources in this example"
  default     = "lmctfy"
}

variable "location" {
  default     = "centralus"
  description = "The Azure Region in which all resources in this example should be provisioned"
}

variable "aks_client_id" {
  description = "The Client ID for the Service Principal to use for this Managed Kubernetes Cluster"
}

variable "aks_client_secret" {
  description = "The Client Secret for the Service Principal to use for this Managed Kubernetes Cluster"
}

