#!/bin/bash

. ./cluster.sh

pushd $INFRA_DIR
  ./destroy-cluster
  if [ $? -ne 0 ]
  then
    exit $?
  fi

  if [ -d "$KIPP_CLUSTER_DIR" ]
  then
    rm -f $KIPP_CLUSTER_DIR/*
  fi
popd

# Remove kubeconfig.to avoid confusion !
rm -f /tmp/kubeconfig

rm -rf $INFRA_DIR
