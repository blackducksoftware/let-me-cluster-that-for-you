#!/bin/bash

# IMPORTANT: This will actually setup kubectl for you.
# This is done by setting env vars locally. 
. ../kube/common.sh

NS="$1"

if [ -z $NS ]; then
	echo "kube-test: No namespace provided !!!"	
	exit 2
fi


# Exit with non zero unless the container exited 0 + not in runnign state.
exit_with_right_code() {
	# Dont trust docker exit code unless status != Running.  LEts make our own
	# exit code here...

	c_state=`$KUBECTL get pod scan-test --show-all --namespace=$NS -o go-template --template='{{.status.phase}}'`
	c_code=`$KUBECTL get pod scan-test --show-all --namespace=$NS -o go-template --template="{{range .status.containerStatuses}}{{.state.terminated.exitCode}}{{end}}"`
	if echo "$c_state" | grep -qi fail ; then
	       echo "EXITING: Container was failed. $c_state $c_code"
	       exit $c_code
	fi
	if echo "$c_state" | grep -qi Succeeded ; then 
		echo "EXITING: Pod test Success $c_state $c_code"
		exit $c_code
	fi

	echo "invalid container state $c_state $c_code"
	$KUBECTL get pod scan-test -o yaml --namespace=$NS	
	exit 1
}

cat << EOF > scantest.yml
apiVersion: v1
kind: Pod
metadata:
  name: scan-test
spec:
  restartPolicy: Never
  containers:
  - name: scan-tester
    image: gcr.io/gke-verification/blackducksoftware/kipp-test:master
    imagePullPolicy: Always
    env:
    - name: HUB_SERVER
      value: nginx-webapp-logstash
    - name: SCALE_BYTES
      value: "200"
EOF


register() {
        export reg_key="QA_hub_external_test"
	echo "Attempting regigstration.... $reg_key"
	reg_pod=`$KUBECTL get pods --namespace=$NS | cut -d' ' -f 1 | grep regi`
	if echo $reg_pod | grep -q registration ; then
		set -x
		$KUBECTL exec -t -i $reg_pod -n $NS -- curl --insecure -X POST https://127.0.0.1:8443/registration/HubRegistration?action=activate\&registrationid=${reg_key}
		$KUBECTL logs $reg_pod -n $NS | tail
		$KUBECTL logs $reg_pod -n $NS | grep -i 'docum\|search\|proj\|'
			
		set +x
	else 
	     echo "no registation pod!!! exiting"
	     exit 111
	fi
}

register
$KUBECTL delete -f scantest.yml --namespace=$NS 2>&1 > /dev/null
$KUBECTL create -f scantest.yml --namespace=$NS
$KUBECTL get po --namespace=NS --show-all

x=0
c_state=`$KUBECTL get pod scan-test --show-all --namespace=$NS -o go-template --template='{{.status.phase}}'`
while echo $c_state | grep -i -q run || echo $c_state | grep -i -q pend ; do
	echo "Trial $x"
	c_state=`$KUBECTL get pod scan-test --show-all --namespace=$NS -o go-template --template='{{.status.phase}}'`
	echo "pod state = $c_state"
	let x++

	# logs
	logs=`$KUBECTL logs  scan-test --namespace=$NS | tail -4`
	echo "**** logs from container == `echo $logs`  ****"

	if [[ $x -gt 45 ]] ; then
		echo "timeout !!!"
		exit_with_right_code
	fi
	sleep 9
done

# If we get this far, then we got past run/pend state, so, test may have passed or failed.  No timeout.
echo "Scan test completed without timing out. Final state $c_state"
exit_with_right_code
