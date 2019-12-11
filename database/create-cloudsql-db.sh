#!/bin/bash

# HOW TO RUN:
# ./create-cloudsql-db.sh [DATABASE_NAME] [MASTER_USER_PASSWORD]
# i.e: ./create-cloudsql-db.sh exampledb masterpassword

# [TODO: make the interface be this]
# ./create-cloudsql-db.sh [DATABASE_NAME] [MASTER_USER_PASSWORD] [POSTGRESQL_VERSION] [DB_SIZE_IN_GB]


# https://news.ycombinator.com/item?id=10736584
set -o errexit -o nounset -o pipefail
# this line enables debugging
set -xv

# Source: https://cloud.google.com/sql/docs/postgres/create-instance

# arguments currently being accepted
# required arguments
DATABASE_NAME=${1}
MASTER_USER_PASSWORD=${2}
DB_REGION=${3}

# static parameters that may be taken as arguments
POSTGRESQL_VERSION=${4:-POSTGRES_9_6}
DB_SIZE_IN_GB=${5:-10}  #gcloud cloudsql, auto storage size increase is enabled by default
STORAGE_TYPE=${6:-SSD}
CPU=${7:-4}
MEMORY=${8:-15360MiB}

# create db
gcloud sql instances create "$DATABASE_NAME" --database-version="$POSTGRESQL_VERSION" --storage-size="$DB_SIZE_IN_GB" \
  --region="${DB_REGION}" --cpu="$CPU" --memory="$MEMORY" --storage-type="$STORAGE_TYPE"
# TODO: restrict it to VPC network, look at these flags
#  --network
#  --authorized-networks

# set the password for the postgres user
gcloud sql users set-password postgres no-host --instance="$DATABASE_NAME" \
  --password="$MASTER_USER_PASSWORD"

gcloud sql instances describe "$DATABASE_NAME"
