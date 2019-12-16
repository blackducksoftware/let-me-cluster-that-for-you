# HOW TO RUN:
# ./create-db.sh [DB_PROVIDER] [NAME] [MASTER_USERNAME] [MASTER_USER_PASSWORD] [DB_REGION]
# i.e: ./create-db.sh rds example_cluster_name postgres postgres


# DATABASE CREATION NOW
# TODO: pull out database part out of this script
# cases for different providers
set -o errexit -o nounset -o pipefail
# this line enables debugging
set -xv

#Mandatory fields
DB_PROVIDER=${1}


main_work_dir="/lmctfy"
db_config_path="${main_work_dir}/ci/kube/configs"

if [[ "${DB_PROVIDER}" == "RDS" ]]; then
  printf "Creating a RDS Database with name: %s" "${2}"
  export DB_PROVIDER="rds"
  export DATABASE_NAME=${2}
  export MASTER_USERNAME=${3:-none}
  export MASTER_USER_PASSWORD=${4:-none}
  export DB_REGION=${5:-us-east-1}
  export DB_SIZE_IN_GB=${6:-20}
  export DB_INSTANCE_CLASS=${7:-db.m4.large}
  export POSTGRESQL_VERSION=${8:-9.6}
  export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-}"
  export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-}"
  export AWS_DEFAULT_REGION="${DB_REGION}"
elif [[ "${DB_PROVIDER}" == "CLOUDSQL" ]]; then
  printf "Creating a CLOUDSQL Database with name: %s" "${2}"
  DB_REGION=${5:-us-east1}
  cd "${main_work_dir}/database" && ./create-cloudsql-db.sh "${2}" "${MASTER_USER_PASSWORD}" "${DB_REGION}"
else
  printf "Don't know this database option"
  exit 1
fi

#### configure and create db 
db_infra_path="${main_work_dir}/ci/infrastructure/modules/database"
base_dir="${main_work_dir}/${DATABASE_NAME}"
if [ ! -d "$base_dir" ]
then
  mkdir ${main_work_dir}/${DATABASE_NAME}
fi
cp -aR $db_infra_path/* "${base_dir}"/
envsubst < "${db_config_path}/db.template" | tee "${base_dir}"/db-main
##copy config file to db infra path

which terraform > /dev/null
if [ $? -ne 0 ]
then
  TF="${DIR}/terraform"
else
  TF="terraform"
fi

# Create the symlink for the specific provider module
pushd ${base_dir}
  # Initialize terraform
  $TF init -var-file=db-main

  # Launch the cluster
  $TF apply -auto-approve -var-file=db-main
popd




