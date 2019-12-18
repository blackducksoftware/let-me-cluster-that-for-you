variable "project_id" {
  description = "The ID of the project in which resources will be provisioned"
  type        = string
  default     = "eng-dev"
}

variable "db_name" {
  description = "The name of the PostgreSQL Database instance"
  default     = "example-postgres-private"
}

variable "network_name" {
  default = "psql-example"
  type    = string
}

variable "region" {
  default = "us-central1"
  type    = string
}

variable "zone" {
  default = "us-central1-b"
  type    = string
}

variable "postgresql_version" {
  default = "POSTGRES_9_6"
  type    = string
}
