provider "google" {
  region = var.region
}

data "google_client_config" "current" {
}

resource "google_compute_network" "default" {
  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  project                  = var.project_id
  name                     = var.network_name
  ip_cidr_range            = "10.127.0.0/20"
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = true
}

resource "random_id" "name" {
  byte_length = 2
}

module "postgresql-db" {
  # https://registry.terraform.io/modules/GoogleCloudPlatform/sql-db/google/2.0.0
  # https://github.com/terraform-google-modules/terraform-google-sql-db/tree/add13c3746692c3bdf926e377e1548d727c59d18/modules/postgresql
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "2.0.0"

  name             = "example-postgresql-${random_id.name.hex}"
  database_version = var.postgresql_version
  project_id       = var.project_id
  zone             = var.zone

  ip_configuration = {
    ipv4_enabled    = true
    private_network = null
    require_ssl     = true
    authorized_networks = [
      {
        name  = var.network_name
        value = google_compute_subnetwork.default.ip_cidr_range
      },
    ]
  }
}
