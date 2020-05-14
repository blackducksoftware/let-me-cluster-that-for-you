variable "prefix" {
  description = "A prefix used for all resources in this example"
  default     = "lmctfy"
}

variable "location" {
  default     = "centralus"
  description = "The Azure Region in which all resources in this example should be provisioned"
}

variable "kubernetes_version" {
  type    = string
  default = "1.15"
}
variable "cluster_name" {
  type    = string
  default = "lmctfycluster"
}

variable "workers_count" {
  type    = string
  default = 2
}

variable "workers_type" {
  type    = string
  default = "Standard_DS4_v2"
}

variable "aks_client_id" {
  description = "The Client ID for the Service Principal to use for this Managed Kubernetes Cluster"
}

variable "aks_client_secret" {
  description = "The Client Secret for the Service Principal to use for this Managed Kubernetes Cluster"
}
variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Azure AKS public API server endpoint."
  type        = list(string)
  default     = [                        # Synopssys external-facing IPs:
                  "149.117.0.0/16",      # snps-1
                  "198.182.32.0/19",     # snps-2
                  "216.85.161.194/32",   # snps-4
                  "50.21.174.162/32",    # Hitakshi Office IP
                  "198.182.56.5/32",     # Hitakshi VPN IP
                  "192.231.134.1/32",    # DC2
                  "193.240.221.236/32",  # Theale and Belfast
                  "58.76.201.220/32",    # South Korea
                  "80.75.109.253/32",    # fuzztds office
		  "35.202.29.179/32",
		  "64.128.208.115/32",
		  "35.237.252.153/32",
                ]
}


variable "rg_name" {
  type = string
}
variable "rg_location" {
  type = string
}

variable "subnet_id" {
  type = string
}

# Uncomment to enable SSH access to nodes
#
# variable "public_ssh_key_path" {
#   description = "The Path at which your Public SSH Key is located. Defaults to ~/.ssh/id_rsa.pub"
#   default     = "~/.ssh/id_rsa.pub"
#}
