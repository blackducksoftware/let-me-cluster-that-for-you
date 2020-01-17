# Quick Start

[Terraform docs about Service Principal](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html)

## Generating a service principal

- install azure cli (`brew install azure-cli`)
- `az login`, it'll open a browser or give you a URL+token
- `export ARM_SUBSCRIPTION_ID="$(az account show | jq -r .id)"`
- `az ad sp create-for-rbac --role="Contributor" --scopes="${ARM_SUBSCRIPTION_ID}" --name $(whoami)-servicePrincipal`
- put it in a file

## Common azure-cli commands

### To list all your accounts

`az account list`

### To see which account you are currently using

`az account show --query "{subscriptionId:id, tenantId:tenantId}"`

### To switch to a particular subscription

`az account set --subscription="subscriptionId"`

### Environment variables needed

export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
