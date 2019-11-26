#!/bin/bash

set -e

eval "$(jq -r '@sh "MASTER=\(.master) SSH_USER=\(.ssh_user) SSH_KEY_FILE=\(.ssh_key_file) RUN=\(.run)"')"

KUBECONFIG=""
if [[ $(echo "$RUN" | tr a-z A-Z) == "TRUE" ]]
then
  if [ ! -f ./kubeconfig ] || [ $(wc -c <./kubeconfig) -eq 0 ]
  then
    scp -i "$SSH_KEY_FILE" -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null "$SSH_USER"@"$MASTER":.kube/config ./kubeconfig
    sed -i.bak "s|server:.*|server: https://$MASTER:8443|" ./kubeconfig
    KUBECONFIG=$(cat ./kubeconfig)
  fi
fi

jq -n --arg kubeconfig "$KUBECONFIG" '{"kubeconfig":$kubeconfig}'
