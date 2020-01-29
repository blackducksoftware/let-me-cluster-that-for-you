# README

## Sources

[Release being used: terraform-google-modules/kubernetes-engine/google/6.1.1](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/6.1.1)
[Simple Regional Cluster with Networking](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/v6.1.1/examples/simple_regional_with_networking)

```bash

export GOOGLE_APPLICATION_CREDENTIALS="<PATH TO SERVICE ACCOUNT>"
export TF_VAR_project_id="<PROJECT_ID>"

# on macOS
# alias t11=/usr/local/opt/terraform@0.11/bin/terraform
alias t12=/usr/local/bin/terraform

t12 init
t12 plan
t12 apply --auto-approve
t12 destroy --auto-approve
```
