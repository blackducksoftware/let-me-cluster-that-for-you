# HOW TO RUN:
# ./create-db.sh [DB_PROVIDER] [NAME] [MASTER_USERNAME] [MASTER_USER_PASSWORD] [DB_REGION]
# i.e: ./create-db.sh rds example_cluster_name postgres postgres
# For cloudsql db
# ./create-db.sh [DB_PROVIDER] [NAME] [MASTER_USERNAME] [MASTER_USER_PASSWORD] [DB_REGION] 


# DATABASE CREATION NOW
# TODO: pull out database part out of this script
# cases for different providers
set -o errexit -o nounset -o pipefail
# this line enables debugging
set -xv

#Mandatory fields
DB_PROVIDER=${1}
NAME=${2}
# optional arguments
MASTER_USERNAME=${3:-none}
MASTER_USER_PASSWORD=${4:-none}

main_work_dir="/lmctfy"

if [[ "${DB_PROVIDER}" == "RDS" ]]; then
  printf "Creating a RDS Database with name: %s" "${NAME}"
  DB_REGION=${5:-us-east-1}
  export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-}"
  export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-}"
  export AWS_DEFAULT_REGION="${DB_REGION}"
  cd "${main_work_dir}/database" && ./create-aws-rds.sh "${NAME}" "${MASTER_USERNAME}" "${MASTER_USER_PASSWORD}"
elif [[ "${DB_PROVIDER}" == "CLOUDQL" ]]; then
  printf "Creating a CLOUDSQL Database with name: %s" "${NAME}"
  DB_REGION=${5:-us-east1}
  cd "${main_work_dir}/database" && ./create-cloudsql-db.sh "${NAME}" "${MASTER_USER_PASSWORD}" "${DB_REGION}"
else
  printf "Don't know this database option"
fi