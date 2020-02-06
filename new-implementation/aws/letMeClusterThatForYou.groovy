pipeline {
    agent {
        label 'master'
    }
    stages {
        stage ('pol-infra-provisioning') {
            steps {
                script {
                    deleteDir()
                    git 'https://github.com/blackducksoftware/let-me-cluster-that-for-you.git'
                    # withCredentials will can retrive all the credentails stored in jenkins and can be used 
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-creds', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'],file(credentialsId: 'gcp-onprem', variable: 'INFRA')]) {
                        sh '''
                            # LOCATION specifies the providers [google/aws/azure]
                            # we need to have common names for all the folder. Until then we need to specify the name of the complete the folder
                            cd new-implementation/${LOCATION}/public-eks-private-postgres-rds
                            
                            # export the credentails based on the providers
                            #AWS
                            export AWS_ACCESS_KEY_ID=\\"$AWS_ACCESS_KEY_ID\\"
                            export AWS_SECRET_ACCESS_KEY=\\"$AWS_SECRET_ACCESS_KEY\\"
                            #GKE
                            #export GOOGLE_APPLICATION_CREDENTIALS=<GOOGLE_APPLICATION_CREDENTIALS>
                            terraform init
                            terraform terraform apply --auto-approve -var=\\"cluster_name=${cluster_name}\\" -var=\\"kubernetes_version=${kubernetes_version}\\" -var=\\"kubernetes_version=${kubernetes_version}\\" -var=\\"region=${region}\\" -var=\\"postgres_version=${postgres_version}\\" -var=\\"\\"
                        ''' 
                        sh '''
                            docker build -t ${location}:${cluster_name} .
                        '''
                        sh '''
                            echo push docker image 
                            #docker push ${location}:${cluster_name}
                        '''
                    }
                }
            }
        }
    }
}