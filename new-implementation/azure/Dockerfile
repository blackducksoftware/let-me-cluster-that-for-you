# Run: "docker run --rm -i hadolint/hadolint < Dockerfile" to ensure best practices!

# KUBECTL (base image here: https://hub.docker.com/r/lachlanevenson/k8s-kubectl/tags?page=1&name=v1.1)
FROM lachlanevenson/k8s-kubectl:v1.17.2 as kubectl-builder


# HELM V3 (base image here: https://hub.docker.com/r/lachlanevenson/k8s-helm/tags?page=1&name=3)
FROM lachlanevenson/k8s-helm:v3.0.2 as helm-builder


# AZURE-CLI (doesn't live on dockerhub: https://hub.docker.com/r/microsoft/azure-cli/)
FROM mcr.microsoft.com/azure-cli as azure-builder


# TERRAFORM (base image here: https://hub.docker.com/r/hashicorp/terraform/tags?page=1&name=0.12)
FROM hashicorp/terraform:0.12.20

# copy all the dependencies
COPY --from=kubectl-builder /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=helm-builder /usr/local/bin/helm /usr/local/bin/helm
COPY --from=azure-builder /usr/local/bin/az /usr/local/bin/az

# RUN kubectl version && helm version && aws --version && gcloud version

LABEL maintainer="Vasiliy Sharapov"

# copy only the stuff we need
# these are needed for terraform
COPY . /lmctfy/azure

WORKDIR /lmctfy/azure

ENTRYPOINT []

