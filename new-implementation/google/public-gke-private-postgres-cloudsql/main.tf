module "custom_gke" {
  source = "../backends/gke-with-vpc"

  project_id         = var.project_id
  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  network_name       = var.network_name
  subnet_name        = var.subnet_name
}


module "custom_postgresql_db" {
  source = "../backends/private-postgres-cloudsql"

  ## outputs from GKE steps
  project_id   = var.project_id
  network_name = "${module.custom_gke.network_name}"
  region       = "${module.custom_gke.region}"

  # use same db name as cluster name
  db_name = var.cluster_name
}
