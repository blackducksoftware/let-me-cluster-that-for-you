#!/bin/bash

set -euo pipefail

git clone https://github.com/Azure/terraform-azurerm-aks.git
pushd terraform-azurerm-aks

echo "Hey, I was gonna write a bash script to do this, but whatever, you figure it out:"
echo "1. You need terraform installed - https://www.terraform.io/downloads.html"
echo "2. You need azcli installed:"
echo "https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest"
echo "3. Make a ~/test.tfvars and set the creds + cluster prefix"
cat << 'EOF' > ~/test.tfvars
kubernetes_version = "1.17.0"
CLIENT_ID = "the-guid-azcli-gave-you-or-ask-vasiliy-for-his"
CLIENT_SECRET = "the-guid-azcli-gave-you-or-ask-vasiliy-for-his"
EOF
echo "prefix = \"$(whoami)$(date +%s)\"" >> ~/test.tfvars
echo "    e.g. :"
set -x
cat ~/test.tfvars
set +x
echo "4. You might wanna edit outputs.tf to add this:"
echo "output \"raw_kube_config\" {"
echo "value = module.kubernetes.raw_kube_config"
echo "}"
echo
echo "Here's a shell, you do whatever you need to get all that ^^^ and then ^D"
bash
terraform version
echo "Cool, here we go..."
sleep 1

set -x
terraform init
TF_LOG_PATH="${HOME}/tf_apply.log" TF_LOG="TRACE" terraform apply -auto-approve -var-file=${HOME}/test.tfvars 
set +x

echo "Cool, hope all went well, here's a shell to mess around, details are in ${HOME}/tf_apply.log"
echo "After you exit tf destroy is gonna run and save the tf_destroy.log in the same place"
bash
echo "Cool, here we go..."
sleep 1

set -x
TF_LOG_PATH="${HOME}/tf_destroy.log" TF_LOG="TRACE" terraform destroy -auto-approve -var-file=${HOME}/test.tfvars 
set +x

popd
echo " ~~ Fin ~~ "
