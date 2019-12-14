#!/bin/bash

# HOW TO RUN:
# ./end-to-end-cluster.sh [CLOUD_PROVIDER] [NAME] [CLUSTER_KUBERNETES_VERSION] [CLUSTER_REGION] [CLUSTER_ZONE]
# i.e: ./end-to-end-cluster.sh aws example_cluster_name 1.16.0 us-east1 us-east1-a
#For AWS we need to mount .aws folder to root or export AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY values


# [TODO: make the interface be this]
# ./end-to-end-cluster.sh [CLOUD_PROVIDER] [NAME] [CLUSTER_KUBERNETES_VERSION] [CLUSTER_REGION] [CLUSTER_ZONE] [STORAGE_PROVISIONER] [INGRESS]
# [TODO: maybe database creation should be separate stage in the pipeline]
# [DB_PROVIDER] [MASTER_USERNAME] [MASTER_USER_PASSWORD]

# https://news.ycombinator.com/item?id=10736584
set -o errexit -o nounset -o pipefail
# this line enables debugging
set -xv

# arguments currently being accepted
# required arguments
CLOUD_PROVIDER=${1}
# static parameters that may be should be taken as arguments
# STORAGE_PROVISIONER=LOCAL_PATH_PROVISIONER
# INGRESS=NGINX_INGRESS
# WORKER_IMAGE="c4.2xlarge"

main_work_dir="/lmctfy"
ci_kube_path="${main_work_dir}/ci/kube"
ci_configs_path="${ci_kube_path}/configs"

# generate ssh keys for infrastructure provision
PWD="$(pwd)"
ssh-keygen -b 2048 -t rsa -f ${PWD}/id_rsa -q -N ""
export PWD="${PWD}"
#################

# Step 1: figure out which config we are going to be using
# cases for different providers
if [[ "${CLOUD_PROVIDER}" == "AWS" ]]; then
  #ci_source_config_filename="kube1.15.4_aws_1m4w"
  export PROVIDER=aws
  export NAME=${2}
  export KUBERNETES_VERSION="${3:-1.15.4}"
  export CLUSTER_REGION="${4:-}"
  export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-}"
  export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-}"
  export AWS_DEFAULT_REGION="${CLUSTER_REGION}"
  export INSTANCE_TYPE="${INSTANCE_TYPE:-c4.2xlarge}"
elif [[ "${CLOUD_PROVIDER}" == "GCP" ]]; then
  #ci_source_config_filename="kube1.15.4_gcp_1m4w"
  export PROVIDER=gcp
  export NAME=${2}
  export KUBERNETES_VERSION="${3:-1.15.4}"
  export CLUSTER_REGION=${4:-}
  export CLUSTER_ZONE=${5:-}
  export INSTANCE_TYPE="${INSTANCE_TYPE:-}"
  export GCP_PROJECT="${GCP_PROJECT}"
  export GCP_JSON_PATH=${GCP_JSON_PATH}
elif [[ "${CLOUD_PROVIDER}" == "EKS" ]]; then
  #ci_source_config_filename="kube1.14_eks_1m4w"
  export PROVIDER=eks
  export NAME=${2}
  export KUBERNETES_VERSION="${3:-1.15.4}"
  export CLUSTER_REGION=${4}
  export INSTANCE_TYPE="${INSTANCE_TYPE:-c4.2xlarge}"
elif [[ "${CLOUD_PROVIDER}" == "DC1" ]]; then
  #ci_source_config_filename="kube1.15.4_vsphere_1m4w"
  export PROVIDER=dc1
  printf "Not supporting this just yet, please wait"
  exit 1
else
  printf "Do not know about this cloud provider %s; exiting now" "${CLOUD_PROVIDER}"
  exit 1
fi

envsubst < "${ci_configs_path}/kube.template" | tee "${ci_configs_path}"/kube-main
ci_source_config_filename=kube-main
ci_source_config_path="${ci_configs_path}/${ci_source_config_filename}"
printf "Using this config: %s as the base" "${ci_source_config_path}"

# Use name and time as the unique id; TODO: make this uniqueness better
now="$(date +%s)" ## (Displays nanoseconds)
ci_destination_config_path="${ci_configs_path}/${now}_${NAME}_${ci_source_config_filename}"

# replace the config with name and version
sed "s/ci/${NAME}-${now}-ci/g" "${ci_source_config_path}" > "${ci_destination_config_path}"

# replace where terraform stuff is stored (-i option edits in place, without the .bak the command will fail on some platforms, such as Mac OSX)
sed -i.bak "s/infra/${NAME}/g" "${ci_kube_path}/cluster.sh"

# run kube-create script with the destination config
cd ${ci_kube_path} && ./kube-create.sh "configs/${now}_${NAME}_${ci_source_config_filename}"

# #wait for cluster creation to finish
# #wait

# copy kubeconfig to configure the rest of the way with yaml
mkdir -p ~/.kube && cp /tmp/kubeconfig ~/.kube/config

addons_dir="${main_work_dir}/k8s-addons"

# Download ingress using helm [TODO: change this]
cd "${addons_dir}/ingress/using-helm-v3" && ./download-ingress.sh

# Download storage
# TODO: if managed kubernetes, don't create a dynamic provisioner
cd "${addons_dir}/storage/external-storage/local-volume/local-path-provisioner" && ./install-local-path-provisioner.sh

### remove ssh keyfiles ###
rm -rf ${PWD}/id_rsa
rm -f ${PWD}/id_rsa.pub
######