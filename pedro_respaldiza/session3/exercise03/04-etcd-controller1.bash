#!/bin/bash

source ./common.bash
export ETCD_SERVER_CSR_PATH=/tmp/etcd_server.csr
export ETCD_SERVER_CERT_CONFIG=/tmp/etcd_cert_config.conf

openssl x509 -req -in "$ETCD_SERVER_CSR_PATH" -CA "$KUBERNETES_CA_CERT_PATH" -CAkey "$KUBERNETES_CA_KEY_PATH" -CAcreateserial -out "$ETCD_SERVER_CERT_PATH"  -extensions v3_req -days 500 -extfile ${ETCD_SERVER_CERT_CONFIG}
