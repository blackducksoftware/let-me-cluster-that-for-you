# README
This is a component for EKS and RDS setup Where RDS is created in private network.
## Sources
```
[ VPC source repo ] https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.23.0
[ RDS source repo ] https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/2.13.0
[ EKS source repo ] https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/8.1.0
```
```
Pre-Requisites:
 Terraform version should be greater than 1.12 
 Make sure ssh public key is present in ~/.ssh folder.
 ```

```bash

export AWS_ACCESS_KEY_ID="<AWS_ACCESS_KEY_ID>"
export AWS_SECRET_ACCESS_KEY="<AWS_SECRET_ACCESS_KEY>"


terraform init 
terraform plan -var-file="<varaible file>"
terraform apply -var-file="<varaible file>"
terraform destroy -var-file="<varaible file>"

```
