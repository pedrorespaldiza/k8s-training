#!/bin/bash

export ADMIN_CSR_IN_PATH=/tmp/admin.csr
export ADMIN_CERT_OUT_PATH=/tmp/admin.crt

## Certificate
openssl x509 -req -in "$ADMIN_CSR_IN_PATH" -CA "$KUBERNETES_CA_CERT_PATH" -CAkey "$KUBERNETES_CA_KEY_PATH" -CAcreateserial -out "$ADMIN_CERT_OUT_PATH"  -days 500 
