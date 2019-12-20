# README

## Sources

[Release being used: terraform-google-modules/kubernetes-engine/google/6.1.1](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/6.1.1)
[Simple Regional Cluster with Networking](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/v6.1.1/examples/simple_regional_with_networking)

```bash

export GOOGLE_APPLICATION_CREDENTIALS="<PATH TO SERVICE ACCOUNT>"

# alias trfm11=/usr/local/opt/terraform@0.11/bin/terraform
alias trfm12=/usr/local/bin/terraform

trfm12 init
trfm12 plan
trfm12 apply
trfm12 destroy
```
