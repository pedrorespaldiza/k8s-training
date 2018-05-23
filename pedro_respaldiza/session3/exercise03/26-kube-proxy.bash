#!/bin/bash
export KUBE_PROXY_CSR_IN_PATH=/tmp/kube-proxy.csr
export KUBE_PROXY_CSR_CONF_IN_PATH=/tmp/kube-proxy_cert_config.conf
export KUBE_PROXY_CERT_OUT_PATH=/tmp/kube-proxy.crt

## Certificate
openssl x509 -req -in "$KUBE_PROXY_CSR_IN_PATH" -CA "$KUBERNETES_CA_CERT_PATH" -CAkey "$KUBERNETES_CA_KEY_PATH" -CAcreateserial -out "$KUBE_PROXY_CERT_OUT_PATH" -days 500
