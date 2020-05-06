# README

## Sources

[Release being used: GoogleCloudPlatform/sql-db/google/3.0.0](https://registry.terraform.io/modules/GoogleCloudPlatform/sql-db/google/3.0.0)
[my-sql and postgres private](https://github.com/terraform-google-modules/terraform-google-sql-db/tree/add13c3746692c3bdf926e377e1548d727c59d18/examples/mysql-and-postgres-private)
[postgresql submodule](https://github.com/terraform-google-modules/terraform-google-sql-db/tree/add13c3746692c3bdf926e377e1548d727c59d18/modules/postgresql)

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
