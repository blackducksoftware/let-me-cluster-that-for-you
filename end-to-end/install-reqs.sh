#!/bin/bash

# https://news.ycombinator.com/item?id=10736584
set -o errexit -o nounset -o pipefail
# this line enables debugging
set -xv


# download kubectl
KUBECTL_OS_ARCH="linux/amd64"
curl -LO --fail --silent --show-error "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/$KUBECTL_OS_ARCH/kubectl" && chmod +x kubectl && mv "kubectl" "/usr/local/bin/"

# download helm (v2.15.1)
# look here for other archs: https://github.com/helm/helm/releases/tag/v2.15.2
# useful script here: https://raw.githubusercontent.com/helm/helm/v2.15.1/scripts/get
HELM_OS_ARCH="linux-amd64"
HELM_VERSION="helm-v2.15.2-$HELM_OS_ARCH.tar.gz"
echo "installing $HELM_VERSION"
curl --fail --silent --show-error "https://get.helm.sh/${HELM_VERSION}" | tar -zxvf - && mv "$HELM_OS_ARCH/helm" "/usr/local/bin/"

# download terraform


# download aws


# download gcp


# download azure-cli



