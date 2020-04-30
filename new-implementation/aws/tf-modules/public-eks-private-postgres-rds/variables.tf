variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}

variable "kubernetes_version" {
  type        = string
  description = "The version of EKS to setup"
}

variable "region" {
  type        = string
  description = "Region of EKS to setup"
}

variable "workers" {
  type        = string
  description = "The number of worker nodes create in the cluster"
  default     = "4"
}

/* variable "depends_on" {
  type = list
  default = []
  }*/

variable "instance_type" {
  type        = string
  description = "Worker node instance type"
}

variable "db_username" {
  type        = string
  description = "Username for database instance"
}

variable "db_password" {
  type        = string
  description = "Password for database instance"
}

variable "postgres_version" {
  type        = string
  description = "Postgres version for database instance"
  default     = "9.6"
}

variable "security_groups" {
  type        = string
  description = "https://www.terraform.io/docs/providers/aws/r/security_group.html#security_groups"
  default     = "default"
}

