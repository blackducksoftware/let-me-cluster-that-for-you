# KUBECTL (base image here: https://hub.docker.com/r/lachlanevenson/k8s-kubectl/tags?page=1&name=v1.1)
FROM lachlanevenson/k8s-kubectl:v1.17.3 as kubectl-builder

# HELM V3 (base image here: https://hub.docker.com/r/lachlanevenson/k8s-helm/tags?page=1&name=3)
FROM lachlanevenson/k8s-helm:v3.1.1 as helm-builder

# TERRAFORM (base image here: https://hub.docker.com/r/hashicorp/terraform/tags?page=1&name=0.12)
FROM hashicorp/terraform:0.12.21

# copy all the dependencies
COPY --from=kubectl-builder /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=helm-builder /usr/local/bin/helm /usr/local/bin/helm
COPY . /lmctfy/aws

WORKDIR /lmctfy/aws


ENV AWSCLI_VERSION "1.14.10"

RUN apk add --no-cache --update openssh-keygen curl
RUN ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

RUN apk -v --update add \
        python \
        py-pip \
        groff \
        less \
        mailcap \
        && \
    pip install --upgrade awscli==$AWSCLI_VERSION s3cmd==2.0.1 python-magic && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*
ENTRYPOINT []
