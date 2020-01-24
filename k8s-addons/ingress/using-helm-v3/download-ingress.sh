#!/bin/bash


# [DEPENDENCIES]: 'bash', 'kubectl', 'helm' (specifically helm v3)
# [USAGE]: ./download-ingress.sh CHART_VALUES_LOCATION


# https://news.ycombinator.com/item?id=10736584
set -o errexit -o nounset -o pipefail
# this line enables debugging
set -xv

# SOURCE: https://github.com/helm/charts/tree/master/stable/nginx-ingress

# optional arguments with defaults
DEFAULT_CHART_VALUES_LOCATION="./nginx-ingress-values.yml"
DEFAULT_NAME="nginx-ingress"
DEFAULT_NAMESPACE="nginx-ingress"

CHART_VALUES_LOCATION=${1:-$DEFAULT_CHART_VALUES_LOCATION}
NAME=${2:-$DEFAULT_NAME}
NAMESPACE=${3:-$DEFAULT_NAMESPACE}

# for helm v3, we have to create namespace first
kubectl create ns "$NAMESPACE"
# also for helm v3, we have to add this repo manually
# TODO: only need to add it if it's not already there
helm repo add stable https://kubernetes-charts.storage.googleapis.com
# helm command to install the stable nginx-ingress chart
helm upgrade --install --namespace "$NAMESPACE" -f "$CHART_VALUES_LOCATION" "$NAME" "stable/nginx-ingress"
