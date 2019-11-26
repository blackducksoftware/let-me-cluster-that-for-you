Senthil took it from: https://github.com/IBM/deploy-ibm-cloud-private/blob/master/extensions/nfs-deployment.yaml

I updated it to match from: https://github.com/kubernetes-incubator/external-storage/tree/master/nfs/deploy/kubernetes

Steps to install NFS provisions

ssh into each node and run sudo yum install -y nfs-utils.x86_64

Open nfs-provisioner and dedicate one node to be completely used for NFS, replace all reference of worker2 node name to your node name
