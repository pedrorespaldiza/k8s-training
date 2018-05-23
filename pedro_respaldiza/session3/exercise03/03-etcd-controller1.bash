#!/bin/bash

source ./common.bash

#
# Cluster storage backend: etcd
#
# At the end of this script you will have a running etcd instance to be used
# by Kubernetes Control Plane
#

echo "Creating etcd certificates"

mkdir -p "$ETCD_CERT_DIR"

#
# Create etcd server certificate
#
export ETCD_SERVER_CSR_PATH=/tmp/etcd_server.csr

## Private key
openssl genrsa -out "$ETCD_SERVER_KEY_PATH" 2048

export ETCD_SERVER_CERT_CONFIG=/tmp/etcd_cert_config.conf

cat <<EOF | tee ${ETCD_SERVER_CERT_CONFIG}
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[v3_req]
subjectAltName = @alt_names
[alt_names]
DNS = ${HOSTNAME}
IP = ${CONTROLLER_PRIVATE_IP}
EOF

scp $ETCD_CLIENT_CSR_PATH ubuntu@$CONTROLLER_PUBLIC_IP:/tmp/
scp $ETCD_CLIENT_KEY_PATH ubuntu@$CONTROLLER_PUBLIC_IP:/tmp/
