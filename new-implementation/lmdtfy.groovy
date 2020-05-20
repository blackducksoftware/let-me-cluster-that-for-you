pipeline {
    agent { 
        node {
          label 'master'
        }
    }
    stages {
        stage('provision'){
            steps{
                build job: 'SRIPATHI/lmctfy-provision-infra', parameters: [string(name: 'provsion_env_for', value: "${provsion_env_for}"), string(name: 'k8_provider', value: "${k8_provider}"), string(name: 'kubernetes_version', value: "${kubernetes_version}"), string(name: 'cluster_name', value: "${cluster_name}"), string(name: 'region', value: "${region}"), string(name: 'external_db_required', value: "${external_db_required}"), string(name: 'db_version', value: "${db_version}")]
            }
        }
        stage('sanity') {
            agent {
                docker {
                image "ksripathi/lmctfy-$k8_provider:latest"
                alwaysPull true
                label 'master'
                args  '-u root:root'
                }
            }
             steps {
                 catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE'){
                 script {
                     sh '''
                        apk add --update --no-cache vim git make musl-dev go curl
                        export GOPATH=/root/go
                        export PATH=${GOPATH}/bin:/usr/local/go/bin:$PATH
                        export GOBIN=$GOROOT/bin
                        mkdir -p ${GOPATH}/src ${GOPATH}/bin
                        export GO111MODULE=on
                        go version
                        '''
                    git branch: 'sanity-tests', url: 'https://github.com/mphammer/synopsysctl.git'

                     withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'lmctfy-testing', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'],file(credentialsId: 'lmctfy-test-gcs-bucket', variable: 'infra_key')]) {
                     if ( "${k8_provider}"  == "aws" ){
                        sh '''
                           base_dir=$(pwd)
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
                               export terragrunt_template="blackduck-vpc-eks"
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
                           cd $terragrunt_template/eks
                           mkdir -p ~/.kube
                           terragrunt output cluster-config > ~/.kube/config
                           export KUBECONFIG=~/.kube/config
                           cd $base_dir                           
                           '''
                        }
                    if ( "${k8_provider}"  == "azure" ){
                        git branch: 'sanity-tests', url: 'https://github.com/mphammer/synopsysctl.git'
                        withCredentials([azureServicePrincipal('lmctfy-azure-creds')]) {
                        sh '''
                           base_dir=$(pwd)
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
                           cd $terragrunt_template/aks
                           mkdir -p ~/.kube
                           terragrunt output kube_config > ~/.kube/config
                           export KUBECONFIG=~/.kube/config
                           cd $base_dir
                           '''
                        }
                      }
                    if ( "${k8_provider}"  == "gcp" ){
                        sh '''
                           base_dir=$(pwd)
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
                           cd $terragrunt_template/gke
                           mkdir -p ~/.kube
                           terragrunt output kubeconfig > ~/.kube/config
                           export KUBECONFIG=~/.kube/config
                           cd $base_dir
                           '''
			    }
			  sh '''
                             pwd
                             go build -ldflags "-X main.version=1.0.0" -o synopsysctl ./cmd/synopsysctl
                             cp ./synopsysctl /usr/local/bin/synopsysctl
                             synopsysctl --version
                             cd dev-tests
                             echo "{" > config.json
                             echo '\"synopsysctlPath\": \"synopsysctl\"' >> config.json  
                             echo "}" >> config.json
                             cat config.json
                             go test synopsysctl-tests/sanity/sanityBlackDuck_test.go -v -count=1 -run ".*"
                             '''
                    }
                }
             }
            }
        }
        stage('teardown'){
            steps{
                build job: 'SRIPATHI/lmctfy-destroy-infra', parameters: [string(name: 'provsion_env_for', value: "${provsion_env_for}"), string(name: 'k8_provider', value: "${k8_provider}"), string(name: 'kubernetes_version', value: "${kubernetes_version}"), string(name: 'cluster_name', value: "${cluster_name}"), string(name: 'region', value: "${region}"), string(name: 'external_db_required', value: "${external_db_required}"), string(name: 'db_version', value: "${db_version}")]
            }
        }
    }
}
