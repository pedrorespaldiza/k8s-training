#!/bin/bash

source ./common.bash

#
# Kubernetes Control Plane: API Server
#
# At the end of this script you will have running API Server
#

echo "Creating kubernetes admin user kubeconfig"

mkdir -p "$ADMIN_CERT_DIR"

#
# Create admin server certificate
#
export ADMIN_CSR_PATH=/tmp/admin.csr

## Private key
openssl genrsa -out "$ADMIN_KEY_PATH" 2048

## Certificate sign request
openssl req -new -key "$ADMIN_KEY_PATH" -out "$ADMIN_CSR_PATH" -subj "/CN=kubernetes/O=system:masters"

## Copy the request to the server (NOT THE PROPER WAY)
scp $ADMIN_CSR_PATH ubuntu@$CONTROLLER_PUBLIC_IP:/tmp/

