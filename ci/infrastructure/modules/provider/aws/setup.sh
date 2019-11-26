#!/usr/bin/env bash

# Allow the ec2-user to sudo without a tty
echo Defaults:ec2-user \!requiretty >> /etc/sudoers
