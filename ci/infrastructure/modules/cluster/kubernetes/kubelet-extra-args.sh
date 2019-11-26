#!/bin/sh

sed -i "s|\(KUBELET_EXTRA_ARGS=.*\)|\1 --fail-swap-on=false|" /etc/sysconfig/kubelet
