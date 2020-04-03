resource "random_id" "name" {
  byte_length = 2
}

locals {
  /*
    Random instance name needed because:
    "You cannot reuse an instance name for up to a week after you have deleted an instance."
    See https://cloud.google.com/sql/docs/mysql/delete-instance for details.

    https://github.com/terraform-google-modules/terraform-google-sql-db/blob/v3.0.0/examples/mysql-private/main.tf#L44
  */
  random_network_name = "${var.network_name}-${random_id.name.hex}"
  # random_subnet_name = "${var.subnet_name}-${random_id.name.hex}"
  ip_range_pods_name     = "ip-range-pods"
  ip_range_services_name = "ip-range-svc"
}

module "gcp-network" {
  # Source:
  # https://registry.terraform.io/modules/terraform-google-modules/network/google/2.0.1
  # https://github.com/terraform-google-modules/terraform-google-network/releases
  source  = "terraform-google-modules/network/google"
  version = "~> 2.0.1"

  project_id   = var.project_id
  network_name = local.random_network_name

  # subnets = []

  subnets = [
    {
      subnet_name   = var.subnet_name
      subnet_ip     = "10.0.0.0/17"
      subnet_region = var.region
    },
  ]

  secondary_ranges = {
    "${var.subnet_name}" = [
      {
        range_name    = local.ip_range_pods_name
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = local.ip_range_services_name
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
  }
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
  min_master_version = data.google_container_engine_versions.supported.latest_master_version
  network            = module.gcp-network.network_name
  subnetwork         = module.gcp-network.subnets_names[0]

  ip_allocation_policy {
    cluster_secondary_range_name  = local.ip_range_pods_name
    services_secondary_range_name = local.ip_range_services_name
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
