# HOW TO RUN:
#For RDS 
# ./delete-db.sh [DB_PROVIDER] [NAME] [DB_REGION]
# i.e: ./delete-db.sh RDS example us-east-1|us-east1

set -o errexit -o nounset -o pipefail
# this line enables debugging
set -xv

#Mandatory fields
DB_PROVIDER=${1}
DATABASE_NAME=${2}
# optional arguments

main_work_dir="/lmctfy"

if [[ "${DB_PROVIDER}" == "RDS" ]]; then
  printf "Creating a RDS Database with name: %s" "${DATABASE_NAME}"
  export DB_REGION=${3:-us-east-1}
  export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-}"
  export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-}"
  export AWS_DEFAULT_REGION="${DB_REGION}"
  #cd "${main_work_dir}/database" && ./delete-aws-rds.sh "${NAME}"
elif [[ "${DB_PROVIDER}" == "CLOUDSQL" ]]; then
  printf "Creating a CLOUDSQL Database with name: %s" "${DATABASE_NAME}"
  DB_REGION=${3:-us-east1}
  cd "${main_work_dir}/database" && ./delete-cloudsql-db.sh "${DATABASE_NAME}" "${DB_REGION}"
else
  printf "Don't know this database option"
fi

base_dir="${main_work_dir}/${DATABASE_NAME}"

which terraform > /dev/null
if [ $? -ne 0 ]
then
  TF="${DIR}/terraform"
else
  TF="terraform"
fi

pushd ${base_dir}
  # Destroy command
  export TF_WARN_OUTPUT_ERRORS=1
  $TF destroy -force -var-file=db-main
popd

if [ $? == 0 ]
then
  rm -rf ${base_dir}
else
  echo "Warning: cluster did not shutdown cleanly.  Inspect the cloud provider for any cluster components and re-run $0 if needed"
  exit 1
fi