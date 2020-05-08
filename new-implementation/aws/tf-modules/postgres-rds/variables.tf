






variable "region" {
  type        = string
  description = "Region of EKS to setup"
  default     = "us-east-1"
}

variable "postgres_version" {
  type        = string
  description = "Postgres version for database instance"
  default     = "9.6"
}

variable "db_name" {
  type        = string
  description = "Name for of database instance"
}


variable "db_username" {
  type        = string
  description = "Username for database instance"
  default     = "postgres"
}

variable "db_password" {
  type        = string
  description = "Password for database instance"
}

variable "vpc_id" {
  type        = string
  description = "Region of EKS to setup"
}

variable "subnets" {
  type        = list
  description = "subnets to setup rds"
}







variable "security_groups" {
  type        = string
  description = "VPC for rds"
}

variable "public_access" {
  type        = bool
  description = "to enable or disable public access to rds"
  default     = true
}

variable "instance_class" {
  type = string
  description = "https://www.terraform.io/docs/providers/aws/r/db_instance.html#instance_class"
  default = "db.t2.micro"
}
