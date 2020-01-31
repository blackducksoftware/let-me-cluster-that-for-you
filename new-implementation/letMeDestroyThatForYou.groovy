pipeline {
    agent {
        label 'master'
    }
    stages {
        stage('destroy-k8s-db') {
            steps {
                script {
                    deleteDir()
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-creds', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'], file(credentialsId: 'gcp-onprem', variable: 'INFRA')]) {
                        echo "$cluster_name"
                        sh '''
                            cat ${INFRA} > infra.json;
                            docker run --name "${cluster_name}-delete" -v $(pwd):/root/creds -v /var/lib/jenkins/kubeconfigs:/opt/kubeconfigs -v /home/bhutwala/.ssh:/root/.ssh ${cluster_name}-lmctfy:${cluster_name} sh -c "cd /lmctfy/google/public-gke-private-postgres-cloudsql; export GOOGLE_APPLICATION_CREDENTIALS=\\"/root/creds/infra.json\\" && terraform destroy --auto-approve -var=\\"project_id=snps-polaris-onprem-dev\\" -var=\\"cluster_name=${cluster_name}\\""
                        '''
                    }
                }
            }
        }
    }
}
