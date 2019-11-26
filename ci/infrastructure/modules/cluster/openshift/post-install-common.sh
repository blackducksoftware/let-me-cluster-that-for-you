#!/bin/sh

sed -i "s|\(.*\)'|\\1 --insecure-registry 172.30.0.0/16'|" /etc/sysconfig/docker
