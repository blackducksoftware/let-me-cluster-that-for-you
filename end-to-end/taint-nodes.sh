#!/bin/bash

# https://news.ycombinator.com/item?id=10736584
set -o errexit -o nounset -o pipefail
# this line enables debugging
set -xv

# Source: https://gist.github.com/jbeda/50ce424c318a1862e5c619ea649f7c53

# logs into the master node and ssh tunnel with prometheus, alert-manager and graphana ports

#SSH_KEY=~/.ssh/id_rsa
#ssh -i $SSH_KEY -A \
#  -L30900:localhost:30900 \
#  -L30903:localhost:30903 \
#  -L30902:localhost:30902 \
#  -o ProxyCommand="ssh -i \"${SSH_KEY}\" ubuntu@x.x.x.x nc %h %p" ubuntu@x.x.x.x

# get all nodes except the master and format the output to feed into pssh
NODES=$(kubectl get nodes --selector=node-role.kubernetes.io/master!="" -o jsonpath="{range .items[*]}-H root@{.status.addresses[?(@.type=='InternalIP')].address} {end}")
echo "$NODES" # should look like this: -H root@10.10.1.114 -H root@10.10.1.122 -H root@10.10.1.206 -H root@10.10.1.249 %

#pssh -i -O StrictHostKeyChecking=no "$NODES" \
#  sudo "sh -c 'sed -e "/cadvisor-port=0/d" -i /etc/systemd/system/kubelet.service.d/10-kubeadm.conf; systemctl daemon-reload; systemctl restart kubelet'"

# TODO: taint and label 50 percent of the worker nodes
kubectl taint nodes worker8-perf-polaris-ci-kube1-15-3-1m9w kubernetes.i
o/os=linux64:NoSchedule

kubectl label node worker1-polaris-qa-ci-kube1-15-3-1m4w os=linux64

