pipeline {
    agent {
        label 'master'
    }
    stages {
        stage('k8s-db-provisioning') {
            steps {
                script {
                    deleteDir()

                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-creds', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'], file(credentialsId: 'gcp-onprem', variable: 'INFRA')]) {
                        echo "$cloud_provider $cluster_name $kubernetes_version $postgresql_version"
                        if ("${cloud_provider}" == "GKE") {
                            sh '''
                                pwd
                                cat ${INFRA} > infra.json
                                docker run --name $cluster_name -v $(pwd):/root/creds -v /var/lib/jenkins/kubeconfigs:/opt/kubeconfigs -v /home/bhutwala/.ssh:/root/.ssh ybhutdocker/lmctfy:google sh -c "export GOOGLE_APPLICATION_CREDENTIALS="/root/creds/infra.json" && export TF_VAR_project_id="snps-polaris-onprem-dev" && export TF_VAR_cluster_name=$cluster_name && cd /lmctfy/google/public-gke-private-postgres-cloudsql; terraform init; terraform apply --auto-approve; cp "$(terraform output kubeconfig_path)" /opt/kubeconfigs/$cluster_name-config" || docker commit $cluster_name $cluster_name-jenkins-lmctfy:$cluster_name
                            '''
                        }

                    }
                }
            }
        }
    }
}
