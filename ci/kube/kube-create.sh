#!/bin/bash 

. ./cluster.sh
. ./common.sh

function setup {
  mkdir -p "$INFRA_DIR"
  cp -aR ../infrastructure/* ./"$INFRA_DIR"
}

function get_kubeconfig {
  # +e because, if this fails, your cluster will never work !
  set +e
  pushd "$INFRA_DIR"
    MASTER_URL=$(./get-cluster-value cluster-master-url)
    # This currently gets the admin cert.
    ./get-cluster-value cluster-config > /tmp/kubeconfig
    echo "*****************************************************************"
    echo "kubeconfig aquired for $MASTER_URL and stored to /tmp/kubeconfig!"
    echo "*****************************************************************"
  popd
  set -e
}

function get_kubectl {
  set +e
  OSNAME=$(uname)
  version=$(cat "$INFRA_DIR"/current-config | grep cluster_manager_version | cut -d'=' -f 2 | tr -d '"' | tr -d [:space:])
  if [ $(tr -dc '.' <<<"$version" | wc -c) -lt 2 ]
  then
    version="$version.0"
  fi
   
  if [[ "$version" == "" ]] ; then
      echo "No version in config.  Infra is broke"
      exit 15
  fi
  if [[ "$OSNAME" == 'Linux' ]]; then
    sudo dnf install -y wget || sudo yum install -y wget
    wget https://storage.googleapis.com/kubernetes-release/release/v"${version}"/bin/linux/amd64/kubectl
  elif [[ "$OSNAME" == 'Darwin' ]]; then
    HOMEBREW_NO_AUTO_UPDATE=1 brew install wget
    wget https://storage.googleapis.com/kubernetes-release/release/v"${version}"/bin/darwin/amd64/kubectl
  fi
  chmod 777 kubectl
  mv -f kubectl /tmp/kubectl
  set -e
}

function create {
  config=$1
  if [[ "$config" == "" ]]
  then
    config="configs/kube1.9.1_aws_1m3w"
  fi

  pushd "$INFRA_DIR"
    ./create-cluster ../$config
    if [ $? -eq 0 ]
    then
      if [ ! -d "$KIPP_CLUSTER_DIR" ]
      then
        mkdir -p "$KIPP_CLUSTER_DIR"
      else
        rm -f "$KIPP_CLUSTER_DIR"/*
      fi
      ln -s "$PWD"/current-config "$KIPP_CLUSTER_DIR"
      ln -s "$PWD"/terraform.tfstate "$KIPP_CLUSTER_DIR"
    else
      echo "Cluster failed to initialize."
      exit 1
    fi
  popd
}

setup
create "$1"
get_kubeconfig
#get_kubectl
