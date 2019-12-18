# README

## Sources

[Release being used: GoogleCloudPlatform/sql-db/google/2.0.0](https://registry.terraform.io/modules/GoogleCloudPlatform/sql-db/google/2.0.0)
[my-sql and postgres private](https://github.com/terraform-google-modules/terraform-google-sql-db/tree/add13c3746692c3bdf926e377e1548d727c59d18/examples/mysql-and-postgres-private)
[postgresql submodule](https://github.com/terraform-google-modules/terraform-google-sql-db/tree/add13c3746692c3bdf926e377e1548d727c59d18/modules/postgresql)

```bash

export GOOGLE_APPLICATION_CREDENTIALS="<PATH TO SERVICE ACCOUNT>"

# alias trfm11=/usr/local/opt/terraform@0.11/bin/terraform
alias trfm12=/usr/local/bin/terraform

trfm12 init
trfm12 plan
trfm12 apply
trfm12 destroy
```
