#!/bin/bash

source ./common.bash

export KUBE_SCHEDULER_CSR_PATH=/tmp/kube-scheduler_server.csr
openssl x509 -req -in "$KUBE_SCHEDULER_CSR_PATH" -CA "$KUBERNETES_CA_CERT_PATH" -CAkey "$KUBERNETES_CA_KEY_PATH" -CAcreateserial -out "$KUBE_SCHEDULER_CERT_PATH" -days 500 
