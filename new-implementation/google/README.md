# README

## Generating credentials

https://cloud.google.com/iam/docs/creating-managing-service-account-keys

tl;dr: `IAM & Admin` -> `Service accounts` -> `More` -> `Create key`  
Save and use the full path to your new  `.json` in `tfvars`

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
