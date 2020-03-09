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
  echo "$0: usage: $0 access_key_file_json_formatted"
  exit 1
fi

credFile="$1"
tfvFile="$(mktemp)"
echo "/tmp/$(basename $PWD).tfvars" > $tfvFile
usingVariable $tfvFile "terraform vars generated file (will be overwritten)"
tfvFile="$(cat $tfvFile && rm $tfvFile)"
echo $tfvFile && [ -r $tfvFile ] && cat $tfvFile

export AWS_ACCESS_KEY_ID="$(cat $credFile | jq -r '."Access key ID"')"
export AWS_SECRET_ACCESS_KEY="$(cat $credFile | jq -r '."Secret access key"')"

read -p "Hit enter to generate $tfvFile or ^C"

cat > $tfvFile <<EOF
# Hey, here's your generated $tfvFile file
# Reminder: hit 'v' in \`less\` to edit with ${VISUAL:-${EDITOR:-"vi"}} or 'q' if it looks good

# eks values
cluster_name       = "$(whoami)$(date +%s)"
kubernetes_version = "1.14"
region             = "us-east-1"
workers            = "4"
instance_type      = ""
security_groups = "sg-7693421e"
# RDS values
db_username      = "postgres"
db_password      = "postgres"
postgres_version = "9.6"
EOF

less $tfvFile

read -p "Hit enter to \`terraform init && terraform plan\` or ^C"
                                           terraform init && terraform plan    -var-file="$tfvFile"
read -p "Hit enter to \`terraform apply\` or ^C"
TF_LOG_PATH="/tmp/$(date +%s)_tf_apply.log"   TF_LOG="TRACE" terraform apply   -var-file="$tfvFile" -auto-approve
read -p "Hit enter to \`terraform destroy\` or ^C"
TF_LOG_PATH="/tmp/$(date +%s)_tf_destroy.log" TF_LOG="TRACE" terraform destroy -var-file="$tfvFile" -auto-approve

