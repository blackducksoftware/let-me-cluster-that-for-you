#/bin/bash
# ASSUMES that you've run kube-deploy and written the kubectl+config to /tmp/ 
/tmp/kubectl --kubeconfig /tmp/kubeconfig --insecure-skip-tls-verify=true $@
