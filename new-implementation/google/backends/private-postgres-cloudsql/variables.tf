variable "region" {
  default = "us-central1"
  type    = string
}

variable "network" {
  default = "default"
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

variable "network_name" {
  default = "psql-example"
  type    = string
}

variable "project_id" {
  type    = string
  default = "eng-dev"
}
