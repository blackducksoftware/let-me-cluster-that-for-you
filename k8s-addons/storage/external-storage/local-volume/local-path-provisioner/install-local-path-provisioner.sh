#!/bin/bash

# https://news.ycombinator.com/item?id=10736584
set -o errexit -o nounset -o pipefail
# this line enables debugging
set -xv


# Source: https://github.com/rancher/local-path-provisioner#installation
# Release v0.0.11
PROVISIONER_VERSION="v0.0.11"

# deploy the Rancher Local Path Provisioner
kubectl apply -f "https://raw.githubusercontent.com/rancher/local-path-provisioner/${PROVISIONER_VERSION}/deploy/local-path-storage.yaml"

# make it the default storageclass
kubectl patch storageclass "local-path" -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
# TODO: in case of kind delete the existing default storageclass
# kubectl delete storageclasses.storage.k8s.io standard

# TODO: test things: example pvc, pod
#kubectl apply -f "https://raw.githubusercontent.com/rancher/local-path-provisioner/${PROVISIONER_VERSION}/examples/pvc.yaml"
#kubectl apply -f "https://raw.githubusercontent.com/rancher/local-path-provisioner/${PROVISIONER_VERSION}/examples/pvc.yaml"
