# Run: "docker run --rm -i hadolint/hadolint < Dockerfile" to ensure best practices!

# KUBECTL (base image here: https://hub.docker.com/r/lachlanevenson/k8s-kubectl/tags?page=1&name=v1.1)
FROM lachlanevenson/k8s-kubectl:v1.17.2 as kubectl-builder


# HELM V3 (base image here: https://hub.docker.com/r/lachlanevenson/k8s-helm/tags?page=1&name=3)
FROM lachlanevenson/k8s-helm:v3.0.2 as helm-builder

# TERRAFORM (base image here: https://hub.docker.com/r/hashicorp/terraform/tags?page=1&name=0.12)
FROM hashicorp/terraform:0.12.24

# copy all the dependencies
COPY --from=kubectl-builder /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=helm-builder /usr/local/bin/helm /usr/local/bin/helm

# RUN kubectl version && helm version && aws --version && gcloud version

LABEL maintainer="Vasiliy Sharapov"

# copy only the stuff we need
# these are needed for terraform
COPY . /lmctfy/azure
ARG TERRAGRUNT=v0.23.12

ADD https://github.com/gruntwork-io/terragrunt/releases/download/$TERRAGRUNT/terragrunt_linux_amd64 /usr/local/bin/terragrunt

RUN chmod +x /usr/local/bin/terragrunt
WORKDIR /lmctfy/azure

ENTRYPOINT []

