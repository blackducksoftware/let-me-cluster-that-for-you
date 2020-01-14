output "project_id" {
  description = "The ID of the project in which resources will be provisioned"
  value       = var.project_id
}

output "region" {
  value = var.region
}

output "cluster_name" {
  description = "Cluster name"
  value       = google_container_cluster.primary.name
}

output "kubernetes_endpoint" {
  description = "The cluster endpoint"
  sensitive   = true
  value       = google_container_cluster.primary.endpoint
}

output "node_version" {
  description = "Version of Kubernetes"
  value       = google_container_cluster.primary.node_version
}

output "kubeconfig_path" {
  description = "Path to kubeconfig file"
  value       = local_file.kubeconfig.filename
}

output "network_name" {
  description = "The name of the VPC being created"
  value       = module.gcp-network.network_name
}

output "subnet_name" {
  description = "The name of the subnet being created"
  value       = module.gcp-network.subnets_names
}

# output "subnet_secondary_ranges" {
#   description = "The secondary ranges associated with the subnet"
#   value       = module.gcp-network.subnets_secondary_ranges
# }
