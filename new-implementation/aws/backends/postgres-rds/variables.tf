variable "db_name" {
  type        = string
  description = "Name for of database instance"
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

variable "region" {
  type        = string
  description = "Region of EKS to setup"
  default     = "us-east-1"
}

variable "security_groups" {
  type        = string
  description = "Region of EKS to setup"
}

variable "subnets" {
  type        = list
  description = "Region of EKS to setup"
}

variable "vpc_id" {
  type        = string
  description = "Region of EKS to setup"
}