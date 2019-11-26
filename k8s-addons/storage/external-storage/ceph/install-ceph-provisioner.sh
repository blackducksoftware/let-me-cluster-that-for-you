#!/bin/bash

# https://news.ycombinator.com/item?id=10736584
set -o errexit -o nounset -o pipefail
# this line enables debugging
set -xv


# Source: https://rook.io/docs/rook/v1.1/ceph-quickstart.html
# Release 1.1
ROOK_VERSION="release-1.1"

# Source: https://rook.io/docs/rook/v1.1/ceph-examples.html
# deploy common resources
kubectl apply -f "https://raw.githubusercontent.com/rook/rook/${ROOK_VERSION}/cluster/examples/kubernetes/ceph/common.yaml"

# deploy ceph operator
kubectl apply -f "https://raw.githubusercontent.com/rook/rook/${ROOK_VERSION}/cluster/examples/kubernetes/ceph/operator.yaml"

# verify the rook-ceph-operator is in the `Running` state before proceeding
kubectl -n rook-ceph get pod

# create a rook ceph cluster
kubectl apply -f "https://raw.githubusercontent.com/rook/rook/${ROOK_VERSION}/cluster/examples/kubernetes/ceph/cluster-test.yaml"

# verify the rook-ceph-operator is in the `Running` state before proceeding
kubectl -n rook-ceph get pod

# TODO: make this configurable, right now ceph block works pretty well

# CEPH BLOCK
# Source: https://rook.io/docs/rook/v1.1/ceph-block.html
# use block storage
kubectl apply -f "https://raw.githubusercontent.com/rook/rook/${ROOK_VERSION}/cluster/examples/kubernetes/ceph/csi/rbd/storageclass.yaml"
# make it the default storageclass
kubectl patch storageclass "rook-ceph-block" -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
# TODO: in case of kind delete the existing default storageclass
#kubectl delete storageclasses.storage.k8s.io standard
# TODO: test things: example pvc, pod
kubectl apply -f "https://raw.githubusercontent.com/rook/rook/${ROOK_VERSION}/cluster/examples/kubernetes/ceph/csi/rbd/pvc.yaml"
kubectl apply -f "https://raw.githubusercontent.com/rook/rook/${ROOK_VERSION}/cluster/examples/kubernetes/ceph/csi/rbd/pod.yaml"

## CEPH FILESYSTEM
## Source: https://rook.io/docs/rook/v1.1/ceph-filesystem.html
## create shared file system; source: https://rook.io/docs/rook/v1.1/ceph-filesystem-crd.html
## TODO: figure out which filesystem yaml to use here
##kubectl apply -f "https://raw.githubusercontent.com/rook/rook/${ROOK_VERSION}/cluster/examples/kubernetes/ceph/filesystem-ec.yaml"
#kubectl apply -f "https://raw.githubusercontent.com/rook/rook/${ROOK_VERSION}/cluster/examples/kubernetes/ceph/filesystem-test.yaml"
## create storageclass for file system
#kubectl apply -f "https://raw.githubusercontent.com/rook/rook/${ROOK_VERSION}/cluster/examples/kubernetes/ceph/csi/cephfs/storageclass.yaml"
## make it the default storageclass
#kubectl patch storageclass "csi-cephfs" -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
## TODO: in case of kind delete the existing default storageclass
##kubectl delete storageclasses.storage.k8s.io standard
## TODO: test things: example pvc, pod
#kubectl apply -f "https://raw.githubusercontent.com/rook/rook/${ROOK_VERSION}/cluster/examples/kubernetes/ceph/csi/cephfs/pvc.yaml"
#kubectl apply -f "https://raw.githubusercontent.com/rook/rook/${ROOK_VERSION}/cluster/examples/kubernetes/ceph/csi/cephfs/pod.yaml"
