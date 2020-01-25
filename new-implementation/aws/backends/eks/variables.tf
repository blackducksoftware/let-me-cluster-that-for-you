variable "cluster_name" {
  type        = string
  description = "Name for of EKS cluster"
}

<<<<<<< HEAD
variable "subnets" {
    type        =  list
    description = " Subnets for EKS to setup"
}

variable "vpc_id" {
    type        =  string
    description = "Vpc for EKS to setup"
}

variable "kubernetes_version" {
  type        = string
  description = "The version of EKS to setup"
  default     = "1.14"
=======
variable "kubernetes_version" {
  type        = string
  description = "The version of EKS to setup"
>>>>>>> 0ff79f351647dd0d8262295cb0161c4bac8984e8
}

variable "region" {
  type        = string
  description = "Region of EKS to setup"
  default     = "us-east-1"
}

variable "workers" {
  type        = string
  description = "The number of worker nodes create in the cluster"
  default     = "4"
}

variable "instance_type" {
  type        = string
  description = "Worker node instance type"
<<<<<<< HEAD
  default     = "m4.large"
=======
>>>>>>> 0ff79f351647dd0d8262295cb0161c4bac8984e8
}

variable "instance_create_timeout" {
  type        = string
  description = "The timeout to use when creating instances"
  default     = "60"
}

variable "public_key_path" {
  type        = string
  description = "The path to a local public key file that will be injected to the instances"
  default     = "~/.ssh/id_rsa.pub"
}