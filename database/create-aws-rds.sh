#!/bin/bash

# HOW TO RUN:
# ./create-aws-rds.sh [DATABASE_NAME] [MASTER_USERNAME] [MASTER_USER_PASSWORD]
# i.e: ./create-aws-rds.sh exampledb examplemaster masterpassword

# [TODO: make the interface be this]
# ./create-aws-rds.sh [DATABASE_NAME] [MASTER_USERNAME] [MASTER_USER_PASSWORD] [DB_SIZE_IN_GB] [DB_INSTANCE_CLASS] [POSTGRESQL_VERSION]


# https://news.ycombinator.com/item?id=10736584
set -o errexit -o nounset -o pipefail
# this line enables debugging
set -xv


# Source: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_CreatePostgreSQLInstance.html

# arguments currently being accepted
# required arguments
DATABASE_NAME=${1}
MASTER_USERNAME=${2}
MASTER_USER_PASSWORD=${3}

# static parameters that may be taken as arguments
DB_SIZE_IN_GB=${4:-20}
DB_INSTANCE_CLASS=${5:-db.m4.large}
POSTGRESQL_VERSION=${6:-9.6}

if aws rds describe-db-instances --db-instance-identifier "$DATABASE_NAME"
then
  printf "\ndatabase named: %s already exists; exiting\n" "$DATABASE_NAME"
  exit 0
else
  printf "\ndatabase with this name does not exist, creating it now"
fi

# TODO: put the database in the same vpc as the cluster

# TODO: figure out the cluster vpc
# aws ec2 describe-vpcs
# aws ec2 describe-vpcs --filters "Name=isDefault, Values=true"

# TODO: create another subnet; https://forums.aws.amazon.com/thread.jspa?threadID=181949
# Source: https://docs.aws.amazon.com/cli/latest/reference/ec2/index.html#ec2

# aws ec2 describe-subnets
# aws ec2 describe-security-groups

# TODO: here, specify the vpc security group id
# Source: https://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
aws rds create-db-instance \
  --db-instance-identifier "${DATABASE_NAME}" \
  --allocated-storage "${DB_SIZE_IN_GB}" \
  --db-instance-class "${DB_INSTANCE_CLASS}" \
  --engine postgres \
  --engine-version "${POSTGRESQL_VERSION}" \
  --master-username "${MASTER_USERNAME}" \
  --master-user-password "${MASTER_USER_PASSWORD}"
# --vpc-security-group-ids \

# tell the users about the db that was just created
aws rds describe-db-instances --db-instance-identifier "${DATABASE_NAME}"


# TODO: keep this in case, we want to test aurora postgres clusters
# Source: https://docs.aws.amazon.com/cli/latest/reference/rds/create-db-cluster.html

# aws rds create-db-cluster \
#   --db-cluster-identifier sample-pg-cluster \
#   --engine aurora-postgresql \
#   --engine-version $POSTGRESQL_VERSION \
#   --master-username masterawsuser \
#   --master-user-password masteruserpassword \
#   --db-subnet-group-name default
