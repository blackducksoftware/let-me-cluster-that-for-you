module "postgresql-db" {
  source  = "../backends/cloudsql"

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
