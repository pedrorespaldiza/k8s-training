#!/bin/bash

source ./common.bash

export KUBELET_CSR_PATH=/tmp/kubelet.csr
export KUBELET_CERT_CONFIG=/tmp/kubelet_cert_config.conf
export THIS_WORKER_IP=$(ifconfig eth0 | awk '/inet addr/ {print $2}' | cut -d: -f2)
export KUBELET_CSR_IN_PATH=/tmp/kubelet.csr
export KUBELET_CSR_CONF_IN_PATH=/tmp/kubelet_cert_config.conf
export KUBELET_CERT_OUT_PATH=/tmp/kubelet.crt

openssl x509 -req -in "$KUBELET_CSR_IN_PATH" -CA "$KUBERNETES_CA_CERT_PATH" -CAkey "$KUBERNETES_CA_KEY_PATH" -CAcreateserial -out "$KUBELET_CERT_OUT_PATH" -days 500 -extensions v3_req -extfile ${KUBELET_CSR_CONF_IN_PATH}  
