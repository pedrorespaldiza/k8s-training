#!/bin/bash

source ./common.bash


export KUBE_CONTROLLER_MANAGER_CSR_PATH=/tmp/kube-controller-manager_server.csr
export SERVICE_ACCOUNT_GEN_CSR_PATH=/tmp/service-account-gen.csr

## Certificate
openssl x509 -req -in "$SERVICE_ACCOUNT_GEN_CSR_PATH" -CA "$KUBERNETES_CA_CERT_PATH" -CAkey "$KUBERNETES_CA_KEY_PATH" -CAcreateserial -out "$SERVICE_ACCOUNT_GEN_CERT_PATH" -days 500 
