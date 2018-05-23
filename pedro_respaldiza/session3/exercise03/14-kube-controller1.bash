#!/bin/bash

source ./common.bash

echo "Creating kube-controller-manager certificates"
export KUBE_CONTROLLER_MANAGER_CSR_PATH=/tmp/kube-controller-manager_server.csr

## Private key
openssl genrsa -out "$KUBE_CONTROLLER_MANAGER_KEY_PATH" 2048

## Certificate sign request
openssl req -new -key "$KUBE_CONTROLLER_MANAGER_KEY_PATH" -out "$KUBE_CONTROLLER_MANAGER_CSR_PATH" -subj "/CN=system:kube-controller-manager/O=system:kube-controller-manager"
## Certificate
openssl x509 -req -in "$KUBE_CONTROLLER_MANAGER_CSR_PATH" -CA "$KUBERNETES_CA_CERT_PATH" -CAkey "$KUBERNETES_CA_KEY_PATH" -CAcreateserial -out "$KUBE_CONTROLLER_MANAGER_CERT_PATH" -days 500 

#
# Create certificate for service account generation
#
export SERVICE_ACCOUNT_GEN_CSR_PATH=/tmp/service-account-gen.csr

## Private key
openssl genrsa -out "$SERVICE_ACCOUNT_GEN_KEY_PATH" 2048

## Certificate sign request
openssl req -new -key "$SERVICE_ACCOUNT_GEN_KEY_PATH" -out "$SERVICE_ACCOUNT_GEN_CSR_PATH" -subj "/CN=service-accounts/O=Kubernetes"

scp $KUBE_CONTROLLER_MANAGER_CSR_PATH ubuntu@$CONTROLLER_PUBLIC_IP:/tmp/
