#!/bin/bash


# [DEPENDENCIES]: 'bash', 'kubectl'
# [USAGE]: ./ingress-yaml.sh


# https://news.ycombinator.com/item?id=10736584
set -o errexit -o nounset -o pipefail
# this line enables debugging
set -xv

# SOURCE: https://kubernetes.github.io/ingress-nginx/deploy/
# https://github.com/kubernetes/ingress-nginx/blob/nginx-0.27.1/deploy/static/mandatory.yaml


# MANDATORY FOR ALL:
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.27.1/deploy/static/mandatory.yaml


# AWS Layer 4 ELB:
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.27.1/deploy/static/provider/aws/service-l4.yaml
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.27.1/deploy/static/provider/aws/patch-configmap-l4.yaml


# AWS NLB (Network Load Balancer):
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.27.1/deploy/static/provider/aws/service-nlb.yaml


# GCE/GKE and Azure:
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.27.1/deploy/static/provider/cloud-generic.yaml


# Bare Metal using Node Port:
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.27.1/deploy/static/provider/baremetal/service-nodeport.yaml

