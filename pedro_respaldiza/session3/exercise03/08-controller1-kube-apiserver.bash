#!/bin/bash

source ./common.bash

export KUBE_APISERVER_CSR_PATH=/tmp/kube-apiserver_server.csr
export KUBE_APISERVER_CERT_CONFIG=/tmp/kube-apiserver_cert_config.conf
# Certificate
openssl x509 -req -in "$KUBE_APISERVER_CSR_PATH" -CA "$KUBERNETES_CA_CERT_PATH" -CAkey "$KUBERNETES_CA_KEY_PATH" -CAcreateserial -out "$KUBE_APISERVER_CERT_PATH"  -extensions v3_req -days 500 -extfile ${KUBE_APISERVER_CERT_CONFIG}
