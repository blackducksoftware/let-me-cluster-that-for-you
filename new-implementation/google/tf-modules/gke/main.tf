terraform {
  backend "gcs" {}
}

provider "google" {
  project     = var.project_id
  region      = var.region
}

resource "random_id" "name" {
  byte_length = 2
}

resource "random_id" "username" {
  byte_length = 14
}

resource "random_id" "password" {
  byte_length = 16
}

data "google_container_engine_versions" "supported" {
  project        = var.project_id
  location       = var.location
  version_prefix = var.kubernetes_version
}

resource "google_container_cluster" "primary" {
  project            = var.project_id
  name               = var.cluster_name
  location           = var.location
  initial_node_count = var.initial_node_count
  node_version       = data.google_container_engine_versions.supported.latest_node_version
  # see upstream issue: https://github.com/terraform-providers/terraform-provider-google/pull/4013
  min_master_version = data.google_container_engine_versions.supported.latest_node_version
  network            = var.network_name
  subnetwork         = var.subnet_name

  ip_allocation_policy {
    cluster_secondary_range_name  = var.ip_range_pods_name
    services_secondary_range_name = var.ip_range_services_name
  }

  master_auth {
    username = random_id.username.hex
    password = random_id.password.hex
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks_cidr_blocks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }

  node_config {
    # https://cloud.google.com/compute/docs/reference/rest/v1/instances#machineType
    machine_type = var.machine_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    # disk_size_gb = 100GB
    # disk_type = pd-ssd
  }
}

data "template_file" "kubeconfig" {
  template = file("${path.module}/kubeconfig-template.yaml")

  vars = {
    cluster_name    = google_container_cluster.primary.name
    user_name       = google_container_cluster.primary.master_auth[0].username
    user_password   = google_container_cluster.primary.master_auth[0].password
    endpoint        = google_container_cluster.primary.endpoint
    cluster_ca      = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
    client_cert     = google_container_cluster.primary.master_auth[0].client_certificate
    client_cert_key = google_container_cluster.primary.master_auth[0].client_key
  }
}

resource "local_file" "kubeconfig" {
  content  = data.template_file.kubeconfig.rendered
  filename = "${path.module}/kubeconfig"
}
