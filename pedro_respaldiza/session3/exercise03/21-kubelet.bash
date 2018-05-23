#!/bin/bash

source ./common.bash

#
# Kubernetes Control Plane: kubelet
#
# At the end of this script you will have running Kube Controller Manager
#

#
# This part must be executed in the worker nodes
#

echo "Creating kubelet certificates"

mkdir -p "$KUBERNETES_CERT_DIR"

#
# Create kubelet certificate
#
export KUBELET_CSR_PATH=/tmp/kubelet.csr

## Private key
openssl genrsa -out "$KUBELET_KEY_PATH" 2048

export KUBELET_CERT_CONFIG=/tmp/kubelet_cert_config.conf
export THIS_WORKER_IP=$(ifconfig eth0 | awk '/inet addr/ {print $2}' | cut -d: -f2)

cat <<EOF | tee ${KUBELET_CERT_CONFIG}
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[v3_req]
subjectAltName = @alt_names
[alt_names]
DNS = ${HOSTNAME}
IP = ${THIS_WORKER_IP}
IP.1 = 127.0.0.1
EOF


## Certificate sign request
openssl req -new -key "$KUBELET_KEY_PATH" -out "$KUBELET_CSR_PATH" -subj "/CN=system:node:${HOSTNAME}/O=system:nodes" -config ${KUBELET_CERT_CONFIG}

## Copy the request to the server (NOT THE PROPER WAY)
scp $KUBELET_CSR_PATH ubuntu@$CONTROLLER_PUBLIC_IP:/tmp/
scp $KUBELET_CERT_CONFIG ubuntu@$CONTROLLER_PUBLIC_IP:/tmp/
