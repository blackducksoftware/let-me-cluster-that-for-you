Senthil took it from: https://github.com/IBM/deploy-ibm-cloud-private/blob/3.1.1/extensions/nfs-deployment.yaml

I updated it to match from: https://github.com/kubernetes-incubator/external-storage/tree/nfs-provisioner-v2.2.2/nfs/deploy/kubernetes/claim.yaml

Steps to install NFS provisions

1. SSH into each node and run `sudo yum install -y nfs-utils.x86_64`

2. Open `nfs-provisioner-deployment.yml` and dedicate one node to be completely used for NFS, replace all reference of `<NODENAME>` to the name of the node you want to use.

3. Run `create-nfs.sh`
