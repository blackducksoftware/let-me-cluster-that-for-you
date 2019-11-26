#!/bin/sh

. ./common.sh

NS=$1

if [ -z $NS ]; then
  echo "missing Namespace arg !, exiting"
  exit 2
fi

$KUBECTL delete ns $NS
