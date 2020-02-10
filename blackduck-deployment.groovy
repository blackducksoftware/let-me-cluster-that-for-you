#!groovy
pipeline {
    agent {
        label 'jenkins-slave'
    }
    stages {
        stage('getkubeconfigfile') {
            agent {
                label 'master'
            }
            steps {
                sh 'cp /var/lib/jenkins/kubeconfigs/${cluster_name}-config .'
                stash includes: '', name: 'kubeconfig'
            }
        }
        stage('getpostgresinfo') {
            agent {
                label 'master'
            }
            steps {
                sh '''
              cp /var/lib/jenkins/tfstate/${cluster_name}-terraform.tfstate .
            '''
                stash includes: '', name: 'tfstate'
            }
        }
        stage('deployblackduck') {
            agent {
                label 'master'
            }
            steps {
                sh '''
                docker run -v /var/lib/jenkins/kubeconfigs/${cluster_name}-config:/blackduck-helm/kubeconfigs/${cluster_name}-config -v /var/lib/jenkins/tfstate/${cluster_name}-terraform.tfstate:/blackduck-helm/terraform.tfstate ybhutdocker/blackduck-helm:ci sh -c "export KUBECONFIG=\\"/blackduck-helm/kubeconfigs/$cluster_name-config\\"; kubectl get ns && kubectl create ns ${blackduck_name}; kubectl create secret generic ${blackduck_name}-blackduck-webserver-certificate --from-file=WEBSERVER_CUSTOM_CERT_FILE=tls.crt --from-file=WEBSERVER_CUSTOM_KEY_FILE=tls.key -n ${blackduck_name}; helm install --wait --timeout 10m ${blackduck_name} . --namespace ${blackduck_name} -f small.yaml --set tlsCertSecretName=${blackduck_name}-blackduck-webserver-certificate --set postgres.isExternal=false --set postgres.ssl=false; kubectl expose deployment -n ${blackduck_name} ${blackduck_name}-blackduck-webserver --name ${blackduck_name}-blackduck-webserver-exposed --type LoadBalancer"
            '''
            // sh '''
            //     docker run -v /var/lib/jenkins/kubeconfigs/${cluster_name}-config:/blackduck-helm/kubeconfigs/${cluster_name}-config -v /var/lib/jenkins/tfstate/${cluster_name}-terraform.tfstate:/blackduck-helm/terraform.tfstate ybhutdocker/blackduck-helm:ci sh -c "export KUBECONFIG=\\"/blackduck-helm/kubeconfigs/$cluster_name-config\\";  external_ip=""; while [ -z $external_ip ]; do echo "Waiting for end point..."; external_ip=$(kubectl get svc -n ${blackduck_name} ${blackduck_name}-blackduck-webserver-exposed --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}"); [ -z "$external_ip" ] && sleep 10; done; echo "End point ready-" && echo $external_ip; export endpoint=$external_ip"
            // '''
            }
        }
    }
}
