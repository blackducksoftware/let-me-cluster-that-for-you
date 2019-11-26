resource "google_compute_network" "cluster" {
  name                    = "${var.prefix}network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  name                     = "${var.prefix}subnet"
  ip_cidr_range            = "${local.subnet_cidr}"
  network                  = "${google_compute_network.cluster.self_link}"
  region                   = "${local.gcp_region}"
  project = "${local.gcp_project_name}"
  private_ip_google_access = true
}

