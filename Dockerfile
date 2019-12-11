# Run: "docker run --rm -i hadolint/hadolint < Dockerfile" to ensure best practices!

# KUBECTL (base image here: https://hub.docker.com/r/lachlanevenson/k8s-kubectl/tags?page=1&name=v1.1)
FROM lachlanevenson/k8s-kubectl:v1.16.3 as kubectl-builder

# alternative
#RUN curl --fail --silent --show-error -O "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
#  chmod +x kubectl && \
#  mv "kubectl" "/usr/local/bin/"

# NO LONGER NEEDED SINCE HELM V3 IS OUT
# UNCOMMENT THIS AND CHANGE end-to-end-cluster.sh  FOR HELM V2 (base image here: https://hub.docker.com/r/lachlanevenson/k8s-helm/tags?page=1&name=2)
# FROM lachlanevenson/k8s-helm:v2.16.1 as helm-builder

# alternative
# (Here is another link: https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz)
#ARG HELM_VERSION="v2.15.2"
#ENV HELM_VERSION=${HELM_VERSION}
#RUN curl --fail --silent --show-error -O "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" && \
#  tar xzf helm-${HELM_VERSION}-linux-amd64.tar.gz && \
#  mv "linux-amd64/helm" "/usr/local/bin/"

# HELM V3 (base image here: https://hub.docker.com/r/lachlanevenson/k8s-helm/tags?page=1&name=3)
FROM lachlanevenson/k8s-helm:v3.0.0 as helm-builder


# GCLOUD-CLI (base image here: https://hub.docker.com/r/google/cloud-sdk/tags?page=1&name=alpine)
FROM google/cloud-sdk:272.0.0-alpine as gcloud-builder

# alternative
#ARG GCLOUD_SDK_VERSION="272.0.0"
#ENV GCLOUD_SDK_VERSION=${GCLOUD_SDK_VERSION}
#ENV PATH /google-cloud-sdk/bin:$PATH
#RUN curl --fail --silent --show-error -O "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz" && \
#  tar xzf google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
#  rm google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
#  gcloud config set core/disable_usage_reporting true && \
#  gcloud config set component_manager/disable_update_check true && \
#  gcloud config set metrics/environment github_docker_image && \
#  gcloud --version

# TERRAFORM (base image here: https://hub.docker.com/r/hashicorp/terraform/tags?page=1&name=0.11)
FROM hashicorp/terraform:0.11.14

# upstream alpine packages can be found here: https://pkgs.alpinelinux.org/packages?name=python3&branch=v3.9&repo=main&arch=x86_64
# helpful command to find these versions: docker run -it --entrypoint sh hashicorp/terraform:0.11.14
RUN apk update
# need python3 for installing aws-cli
# need bash and jq for our scripts
RUN apk add --no-cache python3=3.6.9-r2 \
                        bash=4.4.19-r1 \
                        jq=1.6-r0 \ 
                        gettext=0.19.8.1-r4 \
                        libintl=0.19.8.1-r4	
# in case you need tar
#                        tar=1.32-r0

# copy all the dependencies
COPY --from=kubectl-builder /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=helm-builder /usr/local/bin/helm /usr/local/bin/helm
COPY --from=gcloud-builder /google-cloud-sdk /google-cloud-sdk
ENV PATH /google-cloud-sdk/bin:$PATH

# AWSCLI
# versions hosted here: https://pypi.org/project/awscli/1.16.291/#history
ARG AWS_CLI_VERSION="1.16.291"
RUN pip3 install --no-cache-dir awscli==${AWS_CLI_VERSION}

# aws-iam-authenticator (link to latest here: https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
# needed for authenticating to an eks cluster
RUN curl --fail --silent --show-error -O https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator && \
 chmod +x ./aws-iam-authenticator && \
 mv "aws-iam-authenticator" "/usr/local/bin/"

# RUN kubectl version && helm version && aws --version && gcloud version

LABEL maintainer="Yash Bhutwala"

# copy only the stuff we need
# these are needed for terraform
COPY ./ci/infrastructure /lmctfy/ci/infrastructure
COPY ./ci/kube /lmctfy/ci/kube
# these are for cluster setup
COPY ./end-to-end /lmctfy/end-to-end
COPY ./k8s-addons /lmctfy/k8s-addons
# this one is for database
COPY ./database /lmctfy/database

# TODO: still need to port these from kippernetes
# not needed right now, but will add at some point
#COPY ./ci/openshift /kippernetes/ci/openshift
#COPY ./ci/swarm /kippernetes/ci/swarm

WORKDIR /lmctfy

ENTRYPOINT []
# CMD ["sh", ""]

# ENTRYPOINT ["kubectl"]
# CMD ["help"]
