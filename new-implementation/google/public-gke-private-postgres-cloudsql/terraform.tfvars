project_id = "snps-polaris-onprem-dev"
cluster_name = "yash"
# FROM: https://cloud.google.com/kubernetes-engine/docs/release-notes
# NOTE: currently, does not work for > v.1.15.x
kubernetes_version = "1.14.9-gke.2"
network_name       = "yash-network"
subnet_name        = "yash-subnet"
postgresql_version = "POSTGRES_9_6"
