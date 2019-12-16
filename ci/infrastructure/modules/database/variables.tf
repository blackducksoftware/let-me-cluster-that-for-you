variable "cluster_db_provider_name"{
    type = "string"
    description = "database provider name"
    default = ""
}
variable "cluster_db_region"{
    type = "string"
    description = "database region"
    default = ""
}
variable "cluster_db_postgres_version" {
    type = "string"
    description = "database postgres engine version"
    default = ""
}
variable "cluster_db_name" {
    type = "string"
    description = "database name"
    default = ""
}
variable "cluster_db_size" {
    type = "string"
    description = "database size you want to allocate"
    default = ""
}
variable "cluster_db_instance_class" {
    type = "string"
    description = "database instance type"
    default = ""
}
variable "cluster_db_username" {
    type = "string"
    description = "database user name "
    default = ""
}
variable "cluster_db_password" {
    type = "string"
    description = "database password"
    default = ""
}
variable "cluster_db_snapshot" {
    type = "string"
    description = "To enable final snapshot"
    default = ""
}
variable "cluster_db_multi_az" {
    type = "string"
    description = "To enable multi zone availability"
    default = ""
}
variable "cluster_db_create_timeout" {
    type = "string"
    description = "Database creation timeout"
    default = "15"
}
variable "is_enabled" {
  type = "string"
  description = "Determines if the cluster module should install a cluster manager"
  default = "true"
}