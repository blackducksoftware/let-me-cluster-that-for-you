module "custom_gke" {
  source = "../backends/gke-with-vpc"

  project_id = "eng-dev"
}


module "custom_postgresql_db" {
  source = "../backends/private-postgres-cloudsql"
  project_id = "${module.custom_gke.project_id}"
  network_name = "${module.custom_gke.network_name}"
  db_name = "yash-postgresql"
}
