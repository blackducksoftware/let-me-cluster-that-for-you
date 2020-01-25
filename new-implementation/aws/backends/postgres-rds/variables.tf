variable "instance_class" {
  type        = string
  description = "instance type for postgres "
  default     = "db.t2.large"
}

variable "region" {
  type        = string
  description = "Region of rds to setup"
  default     = "us-east-1"
}

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

variable "subnets" {
    type        =  list
    description = "subnets to setup rds"
}

variable "vpc_id" {
    type        =  string
    description = "VPC for rds"
}

variable "public_access" {
    type        =  bool
    description = "to enable or disable public access to rds"
    default     = true
}