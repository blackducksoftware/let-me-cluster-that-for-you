variable "aws_rds_region" {
  type = "string"
  description = "Specify the region where the instance to be created"
  default = ""
}

variable "db_size_in_gb" {
  type = "string"
  description = "database size you want to allocate"
  default = "20"
}

variable "postgres_version" {
  type = "string"
  description = "database postgres version"
  default = "9.6"
}

variable "db_instance_class" {
  type = "string"
  description = "database instance type"
  default = ""
}

variable "database_name" {
  type = "string"
  description = "database name"
  default = ""
}

variable "master_username" {
  type = "string"
  description = "database user name"
  default = ""
}

variable "master_user_password" {
  type = "string"
  description = "database password"
  default = ""
}

variable "db_snapshot"{
  type = "string"
  description = "To enable database snapshot while deleting the instance"
  default = "false"
}

variable "multi_az"{
  type = "string"
  description = "To enable multi_az for instance"
  default = "false"
}

variable "db_parameter_group" {
  type = "string"
  description = "To assign database patameter group"
  default = ""
}

variable "db_port" {
  type = "string"
  description = "database port"
  default = "5432"
}
variable "db_create_timeout" {
  type = "string"
  description = "database creation timeout"
}
variable "is_enabled" {
  type = "string"
  description = "Determines if the db module should install"
  default = "true"
}