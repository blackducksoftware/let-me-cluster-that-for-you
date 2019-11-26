#!/bin/bash
# IMPORTANT: This will actually setup kubectl for you.
# This is done by setting env vars locally. 
. ../kube/common.sh

NS="$1"
LOG="$2"
if [ -z $NS ]; then
	echo "PANIC kube-test: No namespace provided !!!"	
	exit 2
fi 
if [ -z $2 ]; then
	echo "PANIC: kube-test: No log location provided !!!"
	exit 2
fi

for pod in `$KUBECTL get pods -n $NS | cut -d' ' -f 1`; do 
	echo "KUBE slurping logs for $pod"
	echo "KUBE ************************* KIPP-LOG-START $pod *******************" >> $2
        for c in `$KUBECTL get pods $pod -n $NS -o jsonpath='{.spec.containers[*].name}_'|cut -d'_' -f 1`; do
                $KUBECTL logs $pod -n $NS -c $c >> $2
        done
	echo "*****************************************************************" >> $2
done
