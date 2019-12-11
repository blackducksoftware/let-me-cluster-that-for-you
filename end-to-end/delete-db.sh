# HOW TO RUN:
#For RDS 
# ./delete-db.sh [DB_PROVIDER] [NAME] [DB_REGION]
# i.e: ./delete-db.sh RDS example us-east-1|us-east1

set -o errexit -o nounset -o pipefail
# this line enables debugging
set -xv

#Mandatory fields
DB_PROVIDER=${1}
NAME=${2}
# optional arguments

main_work_dir="/lmctfy"

if [[ "${DB_PROVIDER}" == "RDS" ]]; then
  printf "Creating a RDS Database with name: %s" "${NAME}"
  DB_REGION=${3:-us-east-1}
  export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-}"
  export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-}"
  export AWS_DEFAULT_REGION="${DB_REGION}"
  cd "${main_work_dir}/database" && ./delete-aws-rds.sh "${NAME}"
elif [[ "${DB_PROVIDER}" == "CLOUDSQL" ]]; then
  printf "Creating a CLOUDSQL Database with name: %s" "${NAME}"
  DB_REGION=${3:-us-east1}
  cd "${main_work_dir}/database" && ./delete-cloudsql-db.sh "${NAME}" "${DB_REGION}"
else
  printf "Don't know this database option"
fi