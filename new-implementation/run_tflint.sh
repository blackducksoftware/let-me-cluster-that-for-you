#!/bin/bash
set -euo pipefail


# wget https://github.com/wata727/tflint/releases/download/v0.8.3/tflint_linux_amd64.zip
# unzip tflint_linux_amd64.zip
# mkdir -p /usr/local/tflint/bin
# export PATH=/usr/local/tflint/bin:$PATH
# install tflint /usr/local/tflint/bin
cwd=$(pwd)
aws_tf_dirs="aws/public-eks-private-postgres-rds aws/backends/eks aws/backends/postgres-rds aws/backends/vpc "
azure_tf_dirs="azure/aks-vpc-pg azure/backends/aks-by-terraform-providers azure/backends/azure-db "
google_tf_dirs="google/public-gke-private-postgres-cloudsql google/backends/gke-with-vpc google/backends/private-postgres-cloudsql"

tf_lint_dirs=$aws_tf_dirs$azure_tf_dirs$google_tf_dirs

for folder in $tf_lint_dirs ; do
    cd $folder
    echo "Getting modules on $folder"
    terraform get
    terraform init -backend=false
    echo "Validating modules on $folder"    
    terraform validate
    echo "Running tflint on $folder"
    tflint --deep
    cd $cwd
done
