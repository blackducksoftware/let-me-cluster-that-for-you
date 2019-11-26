#!/bin/bash
set -e

. ./common.sh

NS=$1
PRE_DB_PODS=0
POST_DB_PODS=0
TOTAL_SECONDS=500
TEMPLATE_DIR="../../bitbucket/kube/"

# Smoke tests before we start
function testYaml() {
  if grep $'\t' $1
  then
    echo "Invalid ${1}"
    exit 45
  fi

  if echo "$1" | grep -q post ; then 
	  if cat $1 | grep -q authentication; then
		echo "found auth service "
	  else
		echo "No auth service / deployment !, exiting ($1) !"
		exit 45
	  fi 
  fi
}

function delete_input_ns() {
  # Delete the test namespace, wait till its gone.
  echo "create (delete if necessary) kube..."
  set +e
  while $KUBECTL get ns | grep -q $NS ; do 
	echo "try ns delete..."
	$KUBECTL delete ns $NS
	sleep 5
  done
  set -e
}

function main() {
  echo "dirname for kube sources:  ${TEMPLATE_DIR}"
  echo $(git log -1 --pretty=format:"%h - %s - [%cn]")

  delete_input_ns

  # Pre create tests that valid yaml
  if [[ `$KUBECTL get ns | wc -l ` -gt 5 ]]; then
     echo "TOO MANY KUBE NAMESPACES, SOMETHING IS WRONG with kube cleanups, EXITING!"
     exit 5
  fi 

  $KUBECTL create ns $NS
  pushd ../../bitbucket/kube/
        
	cat README.md | awk '/start quickstart-internal/{f=1} /end quickstart-internal/{f=0;print} f' | sed "s/myhub/${NS}/g"  > /tmp/installhub.sh
	chmod 777 /tmp/installhub.sh
	/tmp/installhub.sh
  popd
}

if [ -z $NS ]; then
  echo "missing Namespace arg !, exiting"
  exit 2
fi

main
