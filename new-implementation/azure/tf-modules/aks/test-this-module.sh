#!/bin/bash

#set -x
set -euo pipefail

function usingVariable() {
  echo "Using \"$(cat $1)\" as $2"
  select ans in "Keep" "Edit";
  do
    case "$ans" in
      Keep ) break;;
      Edit ) ${VISUAL:-${EDITOR:-"vi"}} $1;;
    esac
  done
}

if [[ $# -eq 0 ]] ; then
  echo "$0: usage: $0 Azure_service_principal_file"
  exit 1
fi

spFile="$1"
tfvFile="$(mktemp)"
echo "/tmp/$(basename $PWD).tfvars" > $tfvFile
usingVariable $tfvFile "terraform vars generated file (will be overwritten)"
tfvFile="$(cat $tfvFile && rm $tfvFile)"
echo $tfvFile && [ -r $tfvFile ] && cat $tfvFile

export ARM_TENANT_ID="$(cat $spFile | jq -r .tenant)"
export ARM_CLIENT_SECRET="$(cat $spFile | jq -r .password)"
export ARM_CLIENT_ID="$(cat $spFile | jq -r .appId)"
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET -t $ARM_TENANT_ID
export ARM_SUBSCRIPTION_ID="$(az account show | jq -r .id)"

echo
env | grep ARM_

read -p "Hit enter to generate $tfvFile or ^C"

cat > $tfvFile <<EOF
# Hey, here's your generated $tfvFile file
# Reminder: hit 'v' in \`less\` to edit with ${VISUAL:-${EDITOR:-"vi"}} or 'q' if it looks good
prefix = "$(whoami)$(date +%s)"
kubernetes_version = "1.15"
location = "centralus"
workers_count = "2"
workers_type = "Standard_DS3_v2"
aks_client_id = "${ARM_CLIENT_ID}"
aks_client_secret = "${ARM_CLIENT_SECRET}"
EOF

less $tfvFile

read -p "Hit enter to \`terraform init && terraform plan\` or ^C"
                                           terraform init && terraform plan    -var-file="$tfvFile"
read -p "Hit enter to \`terraform apply\` or ^C"
TF_LOG_PATH="/tmp/$(date +%s)_tf_apply.log"   TF_LOG="TRACE" terraform apply   -var-file="$tfvFile" -auto-approve
read -p "Hit enter to \`terraform destroy\` or ^C"
TF_LOG_PATH="/tmp/$(date +%s)_tf_destroy.log" TF_LOG="TRACE" terraform destroy -var-file="$tfvFile" -auto-approve

