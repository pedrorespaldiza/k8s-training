#!/bin/bash

source ./common.bash

#
# Kubernetes Control Plane: kube-proxy
#
# At the end of this script you will have running Kube Controller Manager
#

echo "Creating kube-proxy certificates"

#
# Create kube-proxy certificate
#
export KUBE_PROXY_CSR_PATH=/tmp/kube-proxy.csr

## Private key
openssl genrsa -out "$KUBE_PROXY_KEY_PATH" 2048

## Certificate sign request
openssl req -new -key "$KUBE_PROXY_KEY_PATH" -out "$KUBE_PROXY_CSR_PATH" -subj "/CN=system:kube-proxy/O=system:node-proxier"

## Copy the request to the server (NOT THE PROPER WAY)
scp $KUBE_PROXY_CSR_PATH ubuntu@$CONTROLLER_PUBLIC_IP:/tmp/
