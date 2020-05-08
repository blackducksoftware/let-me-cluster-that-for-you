output "project_id" {
  description = "The ID of the project in which resources will be provisioned"
  value       = var.project_id
}

output "kubeconfig" {
  value       = local_file.kubeconfig.content
}

# TODO: ideally output region and zone; instead of region and potentially region+zone
output "location" {
  value = var.location
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
