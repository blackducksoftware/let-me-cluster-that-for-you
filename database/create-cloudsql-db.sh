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

# static parameters that may be taken as arguments
POSTGRESQL_VERSION=${3:-POSTGRES_9_6}
DB_SIZE_IN_GB=${4:-10}  #gcloud cloudsql, auto storage size increase is enabled by default
STORAGE_TYPE=${5:-SSD}
CPU=${6:-4}
MEMORY=${7:-15360MiB}

# create db
gcloud sql instances create "$DATABASE_NAME" --database-version="$POSTGRESQL_VERSION" --storage-size="$DB_SIZE_IN_GB" \
  --region="us-east1" --cpu="$CPU" --memory="$MEMORY" --storage-type="$STORAGE_TYPE"
# TODO: restrict it to VPC network, look at these flags
#  --network
#  --authorized-networks

# set the password for the postgres user
gcloud sql users set-password postgres no-host --instance="$DATABASE_NAME" \
  --password="$MASTER_USER_PASSWORD"

gcloud sql instances describe "$DATABASE_NAME"
