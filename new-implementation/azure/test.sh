#!/bin/bash

#set -x
set -euo pipefail

if [[ $# -eq 0 ]] ; then
  echo "$0: usage: $0 Azure_service_principal_file"
  exit 1
fi

spFile="$1"
tfvFile="${HOME}/azure.tfvars"

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
# Reminder: hit 'v' in \`less\` to edit with ${VISUA:-${EDITOR:-"vi"}}
prefix = "$(whoami)$(date +%s)"
kubernetes_version = "1.17.0"
location = "centralus"
CLIENT_ID = "${ARM_CLIENT_ID}"
CLIENT_SECRET = "${ARM_CLIENT_SECRET}"
EOF

less $tfvFile

read -p "Hit enter to continue to \`terraform plan\` or ^C"

pushd minimal-aks/

terraform init
terraform plan    -var-file="$tfvFile"
read -p "Hit enter to \`terraform apply\` or ^C"
terraform apply   -var-file="$tfvFile" -auto-approve
read -p "Hit enter to \`terraform destroy\` or ^C"
terraform destroy -var-file="$tfvFile" -auto-approve

