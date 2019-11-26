#!/bin/bash

# HOW TO RUN:
# ./delete-cloudsql-db.sh [DATABASE_NAME]
# i.e: ./delete-cloudsql-db.sh yash-db

# [TODO: make the interface be this]


# https://news.ycombinator.com/item?id=10736584
set -o errexit -o nounset -o pipefail
# this line enables debugging
set -xv


# arguments currently being accepted
# required arguments
DATABASE_NAME=$1

if ! gcloud sql instances describe "$DATABASE_NAME"
then
  printf "\ndatabase does not exist, no deletion needed, exiting with 0 now\n"
  exit 0
else
  printf "\ndatabase exists, moving on to deletion phase"
fi


# TODO: find out if backups are kept
# TODO: force delete
printf "\nDeleting the database: %s; automate backups will stay\n" "${DATABASE_NAME}"
gcloud sql instances delete "$DATABASE_NAME"
