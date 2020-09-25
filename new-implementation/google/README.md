# README

## Generating credentials

https://cloud.google.com/iam/docs/creating-managing-service-account-keys

tl;dr: `IAM & Admin` -> `Service accounts` -> `More` -> `Create key`
Save and use the full path to your new  `.json` in `tfvars`


## How to run from source

```bash
export GOOGLE_APPLICATION_CREDENTIALS=$HOME/.config/gcloud/manual-put-by-yash/<file.json>
env | grep -i "google"

cd $GOPATH/src/github.com/blackducksoftware/let-me-cluster-that-for-you/new-implemenation/google

source terragrunt-templates/terragrunt_vars.sh
env | grep -i "TF"

mkdir -p temp/terragrunt-templates
cp -r terragrunt-templates/blackduck-vpc-cloudsql-gke/ temp/terragrunt-templates
cp -r tf-modules temp
cp -r terragrunt-templates/terragrunt.hcl temp/terragrunt-templates
cd temp/terragrunt-templates
terragrunt apply-all --auto-approve --terragrunt-non-interactive

# resulting in this error right now:
# Cannot process module Module /Users/bhutwala/gocode/src/github.com/blackducksoftware/let-me-cluster-that-for-you/new-implementation/google/temp/terragrunt-templates/gke (excluded: false, dependencies: [/Users/bhutwala/gocode/src/github.com/blackducksoftware/let-me-cluster-that-for-you/new-implementation/google/temp/terragrunt-templates/vpc]) because one of its dependencies, Module /Users/bhutwala/gocode/src/github.com/blackducksoftware/let-me-cluster-that-for-you/new-implementation/google/temp/terragrunt-templates/vpc (excluded: false, dependencies: []), finished with an error: Missing required GCS remote state configuration project

# Missing required GCS remote state configuration project
# Cannot process module Module /Users/bhutwala/gocode/src/github.com/blackducksoftware/let-me-cluster-that-for-you/new-implementation/google/temp/terragrunt-templates/cloudsql (excluded: false, dependencies: [/Users/bhutwala/gocode/src/github.com/blackducksoftware/let-me-cluster-that-for-you/new-implementation/google/temp/terragrunt-templates/vpc]) because one of its dependencies, Module /Users/bhutwala/gocode/src/github.com/blackducksoftware/let-me-cluster-that-for-you/new-implementation/google/temp/terragrunt-templates/vpc (excluded: false, dependencies: []), finished with an error: Missing required GCS remote state configuration project
```

## To build the image

```bash
docker build -t ybhutdocker/lmctfy:google .
docker push ybhutdocker/lmctfy:google
```

## To run the image

```bash
# this will run terraform apply in a container
docker run ybhutdocker/lmctfy:google sh -c "export GOOGLE_APPLICATION_CREDENTIALS="<PATH TO SERVICE ACCOUNT>" && export TF_VAR_project_id="<PROJECT_ID>" && cd /lmctfy/google/public-gke-private-postgres-cloudsql; terraform init; terraform apply --auto-approve"
```
