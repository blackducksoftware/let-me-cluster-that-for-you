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

data "google_compute_network" "my-network" {
  project = var.project_id
  name    = var.network_name
}

// TODO: figure out why this does not work when combined with the gke module
// errors with network already exists

# module "gcp-network" {
#   source  = "terraform-google-modules/network/google"
#   version = "~> 2.0.1"

#   project_id   = var.project_id
#   network_name = "${"${data.google_compute_network.my-network.self_link}" != null ? "${data.google_compute_network.my-network.name}" : var.network_name}"

#   # network_name = "${"${data.google_compute_network.my-network.self_link}" != null ? "projects/${var.project_id}/global/networks/${data.google_compute_network.my-network.name}" : var.network_name}"

#   subnets = []
# }

module "private-service-access" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  version = "3.0.0"

  project_id = var.project_id
  # vpc_network = module.gcp-network.network_name
  vpc_network = "${data.google_compute_network.my-network.name}"
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
    ipv4_enabled        = false
    private_network     = "projects/${var.project_id}/global/networks/${data.google_compute_network.my-network.name}"
    require_ssl         = false
    authorized_networks = []
  }

  // Optional: used to enforce ordering in the creation of resources.
  module_depends_on = [module.private-service-access.peering_completed]
}
