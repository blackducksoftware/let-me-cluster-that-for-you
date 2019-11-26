#!/bin/bash

# HOW TO RUN:
# ./delete-aws-rds.sh [DATABASE_NAME]
# i.e: ./delete-aws-rds.sh yash-db

# [TODO: make the interface be this]
# ./delete-aws-rds.sh [DATABASE_NAME] [SNAPSHOT]


# https://news.ycombinator.com/item?id=10736584
set -o errexit -o nounset -o pipefail
# this line enables debugging
set -xv


# arguments currently being accepted
# required arguments
DATABASE_NAME=$1
# optional arguments
SNAPSHOT=${2:-YES}

if ! aws rds describe-db-instances --db-instance-identifier "$DATABASE_NAME"
then
  printf "\ndatabase does not exist, no deletion needed, exiting with 0 now\n"
  exit 0
else
  printf "\ndatabase exists, moving on to deletion phase"
fi

# Source: https://docs.aws.amazon.com/cli/latest/reference/rds/delete-db-instance.html#delete-db-instance

if [[ $SNAPSHOT == "NO" ]]; then
  printf "\nSkipping taking final snapshot, deleting the database: %s; automate backups will stay\n" "${DATABASE_NAME}"
  aws rds delete-db-instance \
    --db-instance-identifier "${DATABASE_NAME}" \
    --skip-final-snapshot
else
  FINAL_SNAPSHOT_NAME="${DATABASE_NAME}-finalsnapshot"
  printf "\nDeleting the database: %s; storing final snapshot as: %s; automate backups will be deleted\n" "${DATABASE_NAME}" "${FINAL_SNAPSHOT_NAME}"
  aws rds delete-db-instance \
    --db-instance-identifier "${DATABASE_NAME}" \
    --final-db-snapshot-identifier "${FINAL_SNAPSHOT_NAME}" \
    --delete-automated-backups
fi
