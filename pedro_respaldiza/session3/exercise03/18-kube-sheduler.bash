#!/bin/bash

source ./common.bash

#
# Kubernetes Control Plane: kube-scheduler
#
# At the end of this script you will have running Kube Controller Manager
#

echo "Creating kube-scheduler certificates"

#
# Create kube-scheduler certificate
#
export KUBE_SCHEDULER_CSR_PATH=/tmp/kube-scheduler_server.csr

## Private key
openssl genrsa -out "$KUBE_SCHEDULER_KEY_PATH" 2048

## Certificate sign request
openssl req -new -key "$KUBE_SCHEDULER_KEY_PATH" -out "$KUBE_SCHEDULER_CSR_PATH" -subj "/CN=system:kube-scheduler/O=system:kube-scheduler"
scp $KUBE_SCHEDULER_CSR_PATH ubuntu@$CONTROLLER_PUBLIC_IP:/tmp
