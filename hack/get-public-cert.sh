#!/bin/bash

# https://news.ycombinator.com/item?id=10736584
set -o errexit -o nounset -o pipefail
# this line enables debugging
set -xv


read -r -p "Server (e.g.: jira.dc1.lan): "; echo | openssl s_client -showcerts -servername "${REPLY}" -connect "${REPLY}":443 2>/dev/null | openssl x509 -inform pem -outform DER > cert.cer
