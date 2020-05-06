#!/bin/sh

export TF_VAR_location="us-east1-b"
export TF_VAR_region="us-east1"
export TF_VAR_kubernetes_version="1.15"
export TF_VAR_cluster_name="lmdtfy-testing-eks"
export TF_VAR_project_id="snps-polaris-onprem-dev"

export TF_VAR_db_name="lmdtfytesting"
export TF_VAR_db_username="postgres"
export TF_VAR_db_password="postgres"
export TF_VAR_postgresql_version="POSTGRES_9_6"

