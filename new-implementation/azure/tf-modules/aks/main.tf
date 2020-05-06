terraform {
  backend "gcs" {}
}
locals {
  random_prefix = "${var.prefix}-${random_id.tf-k8s-acc.hex}"
}

provider "azurerm" {
  version = "~>1.44"
}

data "azurerm_kubernetes_service_versions" "current" {
  location       = var.location
  version_prefix = var.kubernetes_version
}

resource "random_id" "tf-k8s-acc" {
  byte_length = 3
}

resource "azurerm_kubernetes_cluster" "tf-k8s-acc" {
  name                = "${local.random_prefix}-cluster"
  resource_group_name = var.rg_name
  location            = var.rg_location
  dns_prefix          = "${local.random_prefix}-cluster"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  api_server_authorized_ip_ranges = var.cluster_endpoint_public_access_cidrs
  # Uncomment to enable SSH access to nodes
  #
  # linux_profile {
  #   admin_username = "acctestuser1"
  #   ssh_key {
  #     key_data = "${file(var.public_ssh_key_path)}"
  #   }
  # }

  agent_pool_profile {
    name            = "agentpool"
    count           = var.workers_count
    vm_size         = var.workers_type
    os_type         = "Linux"
    os_disk_size_gb = 30

    # Required for advanced networking
    vnet_subnet_id = var.subnet_id
  }

  service_principal {
    client_id     = var.aks_client_id
    client_secret = var.aks_client_secret
  }

  role_based_access_control {
    enabled = true
  }

  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
  }
}

resource "local_file" "kubeconfig" {
  content  = azurerm_kubernetes_cluster.tf-k8s-acc.kube_config_raw
  filename = "${path.module}/kubeconfig"
}

