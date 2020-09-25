# README
This is a component for EKS and RDS setup Where RDS is created in private network.

## Build Docker Image

```bash
docker build . -t lmctfy:aws
```

## Run through Docker

```bash
docker run -v $(pwd):/root/creds lmctfy:aws sh -c 'export AWS_DEFAULT_REGION="<region>";export AWS_ACCESS_KEY_ID="<access-key>";export AWS_SECRET_ACCESS_KEY="<secret-key>"; cd terragrunt-templates;terragrunt apply-all --auto-approve --terragrunt-non-interactive;'
```

## Generating AWS creds

Go to https://console.aws.amazon.com/iam/home?#/security_credentials

Click `Create access key`

Click `Download .csv file`

Use a text editor to rearrange the file into aws-credfile.json, e.g.:
```
$ cat aws-credfile.json
{
  "Access key ID": "ASDFG1HJKL2ZXCVB3NM4",
  "Secret access key": "MjU7nHy6BgT5vFr4Cde3+uytrewq123456789POI"
}
```

Now you can yoink the values like so (mind the quotes):

`cat aws-credfile.json | jq -r '."Access key ID"'`

`cat aws-credfile.json | jq -r '."Secret access key"'`


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
