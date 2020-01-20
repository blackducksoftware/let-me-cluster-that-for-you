# Generatnig a service principal

- install azure cli
- `az login`, it'll open a browser or give you a URL+token
- `export ARM_SUBSCRIPTION_ID="$(az account show | jq -r .id)"`
- `az ad sp create-for-rbac --role="Contributor" --scopes="${ARM_SUBSCRIPTION_ID}" --name $(whoami)-servicePrincipal`
- put it in a file
