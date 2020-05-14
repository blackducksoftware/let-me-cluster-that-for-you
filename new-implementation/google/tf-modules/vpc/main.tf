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

locals {
  /*
    Random instance name needed because:
    "You cannot reuse an instance name for up to a week after you have deleted an instance."
    See https://cloud.google.com/sql/docs/mysql/delete-instance for details.

    https://github.com/terraform-google-modules/terraform-google-sql-db/blob/v3.0.0/examples/mysql-private/main.tf#L44
  */
  #random_network_name = "${var.network_name}-${random_id.name.hex}"
  #random_subnet_name = "${var.subnet_name}-${random_id.name.hex}"
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
  #network_name = local.random_network_name
  network_name = var.network_name

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
