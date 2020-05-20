pipeline {
    agent {
        label 'master'
    }
    stages {
        stage('provisioning') {
            agent {
                docker {
                image "ksripathi/lmctfy-$k8_provider:latest"
                alwaysPull true
                label 'master'
                args  '-u root:root'
                }
            }
             steps {
                 script {
                     deleteDir()
                     withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'lmctfy-testing', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'],file(credentialsId: 'lmctfy-test-gcs-bucket', variable: 'infra_key')]) {
                     if ( "${k8_provider}"  == "aws" ){
                        sh '''
                           if [[ $external_db_required == "Yes" && $provsion_env_for == "Reporting" ]]
                           then
                               export terragrunt_template="reporting-vpc-postgres-eks"
                           elif [[ $external_db_required == "No" && $provsion_env_for == "Reporting" ]]
                           then
                               export terragrunt_template="reporting-vpc-eks"
                           elif [[ $external_db_required == "Yes" && $provsion_env_for == "Blackduck_Hub" ]]
                           then
                               export terragrunt_template="blackduck-vpc-postgres-eks"
                           else
                               export terragrunt_template="blackduck-vpc-postgres-eks"
                           fi
                           export GOOGLE_APPLICATION_CREDENTIALS="${infra_key}"
                           export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                           export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                           export TF_VAR_region="$region"
                           export TF_VAR_kubernetes_version="$kubernetes_version"
                           export TF_VAR_cluster_name="$cluster_name"
                           export TF_VAR_db_name="$cluster_name"
                           export TF_VAR_db_password="dbpassword"
                           
                           cd /lmctfy/aws/
                           mkdir -p temp/terragrunt-templates
                           cp -r terragrunt-templates/$terragrunt_template temp/terragrunt-templates/
                           cp -r terragrunt-templates/terragrunt.hcl temp/terragrunt-templates
                           cp -r tf-modules temp/
                           cd  temp/terragrunt-templates
                           terragrunt destroy-all --auto-approve --terragrunt-non-interactive
                           '''
                        }
                    if ( "${k8_provider}"  == "azure" ){
                        withCredentials([azureServicePrincipal('lmctfy-azure-creds')]) {
                        sh '''
                           if [[ $external_db_required == "Yes" && $provsion_env_for == "Reporting" ]]
                           then
                               export terragrunt_template="reporting-vnet-postgres-aks"
                           elif [[ $external_db_required == "No" && $provsion_env_for == "Reporting" ]]
                           then
                               export terragrunt_template="reporting-vnet-aks"
                           elif [[ $external_db_required == "Yes" && $provsion_env_for == "Blackduck_Hub" ]]
                           then
                               export terragrunt_template="blackduck-vnet-postgres-aks"
                           else
                               export terragrunt_template="blackduck-vnet-aks"
                           fi
                           export GOOGLE_APPLICATION_CREDENTIALS="${infra_key}"
                           export TF_VAR_aks_client_secret=$AZURE_CLIENT_SECRET
                           export TF_VAR_aks_client_id=$AZURE_CLIENT_ID
                           export TF_VAR_location="$region"
                           export TF_VAR_pg_server_name="$cluster_name"
                           export TF_VAR_pg_version="$db_version"
                           export TF_VAR_kubernetes_version="$kubernetes_version"
                           export TF_VAR_cluster_name="$cluster_name"
                           export TF_VAR_db_name="$cluster_name"
                           export TF_VAR_db_password="dbpassword"
                           export ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID

                           export ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET

                           export ARM_TENANT_ID=$AZURE_TENANT_ID

                           export ARM_CLIENT_ID=$AZURE_CLIENT_ID
                           
                           cd /lmctfy/azure/
                           mkdir -p temp/terragrunt-templates
                           cp -r terragrunt-templates/$terragrunt_template temp/terragrunt-templates/
                           cp -r terragrunt-templates/terragrunt.hcl temp/terragrunt-templates
                           cp -r tf-modules temp/
                           cd  temp/terragrunt-templates
                           terragrunt destroy-all --auto-approve --terragrunt-non-interactive
                           '''
                        }
                      }
                    if ( "${k8_provider}"  == "gcp" ){
                        sh '''
                           if [[ $external_db_required == "Yes" && $provsion_env_for == "Reporting" ]]
                           then
                               export terragrunt_template="reporting-vpc-cloudsql-gke"
                           elif [[ $external_db_required == "No" && $provsion_env_for == "Reporting" ]]
                           then
                               export terragrunt_template="reporting-vpc-gke"
                           elif [[ $external_db_required == "Yes" && $provsion_env_for == "Blackduck_Hub" ]]
                           then
                               export terragrunt_template="blackduck-vpc-cloudsql-gke"
                           else
                               export terragrunt_template="blackduck-vpc-gke"
                           fi
                           export GOOGLE_APPLICATION_CREDENTIALS="${infra_key}"
                           network_name=$(echo "$cluster_name" | tr '[:upper:]' '[:lower:]')"-network"
                           subnet_name=$(echo "$cluster_name" | tr '[:upper:]' '[:lower:]')"-subnet"
                           export TF_VAR_network_name=$network_name
                           export TF_VAR_subnet_name=$subnet_name
                           export TF_VAR_location=$region"-b"
                           export TF_VAR_region=$region
                           export TF_VAR_kubernetes_version=$kubernetes_version
                           export TF_VAR_cluster_name=$cluster_name
                           export TF_VAR_project_id="snps-polaris-onprem-dev"
                           export TF_VAR_db_name="lmdtfytesting"
                           export TF_VAR_db_username="postgres"
                           export TF_VAR_db_password="postgres"
                           if [ $db_version == "9.6" ]
                           then
                                export TF_VAR_postgresql_version="POSTGRES_9_6"
                           fi
                           echo $TF_VAR_postgresql_version
                           cd /lmctfy/google/
                           mkdir -p temp/terragrunt-templates
                           cp -r terragrunt-templates/$terragrunt_template temp/terragrunt-templates/
                           cp -r terragrunt-templates/terragrunt.hcl temp/terragrunt-templates
                           cp -r tf-modules temp/
                           cd  temp/terragrunt-templates
                           terragrunt destroy-all --auto-approve --terragrunt-non-interactive
                           '''
                        }
                    }
                }
            }
        }
    }
}
