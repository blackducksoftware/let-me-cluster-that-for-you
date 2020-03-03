variable "project_id" {
  description = "The ID of the project in which resources will be provisioned"
  type        = string
}



variable "region" {
  description = "The region of the Cloud SQL resources"
  type        = string
  default     = "us-east1"
}


variable "postgresql_version" {
  description = "Version of the PostgreSQL Database instance"
  type        = string
  default     = "POSTGRES_9_6"
}

variable "tier" {
  description = "The tier for the master instance."
  type        = string
  default     = "db-f1-micro"
}

variable "disk_size" {
  description = "The disk size for the master instance."
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "The disk type for the master instance."
  type        = string
  default     = "PD_SSD"
}

variable "db_name" {
  description = "The name of the PostgreSQL Database instance"
  type        = string
  default     = "example-postgres-private"
}

variable "pguser" {
  type        = string
  description = "The name of the default user for database instance"
  # TODO: defaulted for blackduck
  default     = "blackduck"
}

variable "network_name" {
  description = "Name of the VPC"
  type        = string
  default     = "psql-network"
}






variable "zone" {
  description = "The zone for the master instance, it should be something like: `a`, `c`."
  type        = string
  default     = "b"
}

