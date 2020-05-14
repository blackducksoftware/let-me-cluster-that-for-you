# Run: "docker run --rm -i hadolint/hadolint < Dockerfile" to ensure best practices!

# KUBECTL (base image here: https://hub.docker.com/r/lachlanevenson/k8s-kubectl/tags?page=1&name=v1.1)
FROM lachlanevenson/k8s-kubectl:v1.17.3 as kubectl-builder


# HELM V3 (base image here: https://hub.docker.com/r/lachlanevenson/k8s-helm/tags?page=1&name=3)
FROM lachlanevenson/k8s-helm:v3.1.1 as helm-builder


# GCLOUD-CLI (base image here: https://hub.docker.com/r/google/cloud-sdk/tags?page=1&name=alpine)
FROM google/cloud-sdk:283.0.0-alpine as gcloud-builder


# TERRAFORM (base image here: https://hub.docker.com/r/hashicorp/terraform/tags?page=1&name=0.12)
FROM hashicorp/terraform:0.12.21

# copy all the dependencies
COPY --from=kubectl-builder /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=helm-builder /usr/local/bin/helm /usr/local/bin/helm
COPY --from=gcloud-builder /google-cloud-sdk /google-cloud-sdk
ENV PATH /google-cloud-sdk/bin:$PATH

# RUN kubectl version && helm version && aws --version && gcloud version

LABEL maintainer="Yash Bhutwala"
ARG TERRAGRUNT=v0.23.12

ADD https://github.com/gruntwork-io/terragrunt/releases/download/$TERRAGRUNT/terragrunt_linux_amd64 /usr/local/bin/terragrunt

RUN chmod +x /usr/local/bin/terragrunt
# copy only the stuff we need
# these are needed for terraform
COPY . /lmctfy/google

WORKDIR /lmctfy/google

ENTRYPOINT []
