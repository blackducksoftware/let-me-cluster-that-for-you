resource "random_id" "name" {
  byte_length = 2
}

locals {
  /*
    Random instance name needed because:
    "You cannot reuse an instance name for up to a week after you have deleted an instance."
    See https://cloud.google.com/sql/docs/mysql/delete-instance for details.
  */
  instance_name = "${var.db_name}-${random_id.name.hex}"
}

resource "google_compute_network" "default" {
  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  project                  = var.project_id
  name                     = var.subnet_name
  ip_cidr_range            = "10.127.0.0/20"
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = true
}

module "postgresql-db" {
  # https://registry.terraform.io/modules/GoogleCloudPlatform/sql-db/google/3.0.0
  # https://github.com/terraform-google-modules/terraform-google-sql-db/tree/v3.0.0/modules/postgresql
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "3.0.0"

  project_id       = var.project_id
  name             = local.instance_name
  database_version = var.postgresql_version
  tier             = var.tier
  disk_size        = var.disk_size
  disk_type        = var.disk_type
  region           = var.region
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

data "google_client_config" "current" {
}
