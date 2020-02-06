# Run: "docker run --rm -i hadolint/hadolint < Dockerfile" to ensure best practices!

# KUBECTL (base image here: https://hub.docker.com/r/lachlanevenson/k8s-kubectl/tags?page=1&name=v1.1)
FROM lachlanevenson/k8s-kubectl:v1.17.2 as kubectl-builder


# HELM V3 (base image here: https://hub.docker.com/r/lachlanevenson/k8s-helm/tags?page=1&name=3)
FROM lachlanevenson/k8s-helm:v3.0.2 as helm-builder


# TERRAFORM (base image here: https://hub.docker.com/r/hashicorp/terraform/tags?page=1&name=0.12)
FROM hashicorp/terraform:0.12.20

# AWSCLI
# versions hosted here: https://pypi.org/project/awscli/1.17.5/#history
ARG AWS_CLI_VERSION="1.17.5"
RUN pip3 install --no-cache-dir awscli==${AWS_CLI_VERSION}

# aws-iam-authenticator (link to latest here: https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
# needed for authenticating to an eks cluster
RUN curl --fail --silent --show-error -O https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator && \
 chmod +x ./aws-iam-authenticator && \
 mv "aws-iam-authenticator" "/usr/local/bin/"

# copy all the dependencies
COPY --from=kubectl-builder /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=helm-builder /usr/local/bin/helm /usr/local/bin/helm
COPY --from=gcloud-builder /google-cloud-sdk /google-cloud-sdk
ENV PATH /google-cloud-sdk/bin:$PATH

# RUN kubectl version && helm version && aws --version && gcloud version

LABEL maintainer="Yash Bhutwala"

# copy only the stuff we need
# these are needed for terraform
COPY . /lmctfy/aws

WORKDIR /lmctfy/aws

ENTRYPOINT []
