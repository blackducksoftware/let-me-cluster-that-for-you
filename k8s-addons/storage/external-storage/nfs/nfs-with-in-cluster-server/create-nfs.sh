#!/bin/bash

# https://news.ycombinator.com/item?id=10736584
set -o errexit -o nounset -o pipefail
# this line enables debugging
set -xv


# [TODO: automate install nfs-utils]
# sudo yum install -y nfs-utils.x86_64

NFS_RBAC_LOCATION="nfs-provisioner-rbac.yml"
NFS_DEPLOYMENT_LOCATION="nfs-provisioner-deployment.yml"
NFS_STORAGE_CLASS="nfs-provisioner-storage-class.yml"

kubectl create ns "nfs-provisioner"
kubectl apply -f $NFS_RBAC_LOCATION $NFS_DEPLOYMENT_LOCATION $NFS_STORAGE_CLASS
