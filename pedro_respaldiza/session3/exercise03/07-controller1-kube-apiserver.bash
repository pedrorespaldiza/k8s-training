
#!/bin/bash

source ./common.bash

#
# Kubernetes Control Plane: API Server
#
# At the end of this script you will have running API Server
#

echo "Creating kube-apiserver certificates"

#
# Create kube-apiserver server certificate
#
export KUBE_APISERVER_CSR_PATH=/tmp/kube-apiserver_server.csr

## Private key
openssl genrsa -out "$KUBE_APISERVER_KEY_PATH" 2048

export KUBE_APISERVER_CERT_CONFIG=/tmp/kube-apiserver_cert_config.conf

cat <<EOF | tee ${KUBE_APISERVER_CERT_CONFIG}
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[v3_req]
subjectAltName = @alt_names
[alt_names]
DNS = ${HOSTNAME}
IP = ${CONTROLLER0_PRIVATE_IP}
IP.1 = 127.0.0.1
IP.2 = ${CONTROLLER_PUBLIC_IP}
IP.3 = ${KUBE_APISERVER_SERVICE_IP}
EOF

## Certificate sign request
openssl req -new -key "$KUBE_APISERVER_KEY_PATH" -out "$KUBE_APISERVER_CSR_PATH" -subj "/CN=kubernetes/O=Kubernetes" -config ${KUBE_APISERVER_CERT_CONFIG}
scp $KUBE_APISERVER_CSR_PATH ubuntu@$CONTROLLER_PUBLIC_IP:/tmp/
scp $KUBE_APISERVER_CERT_CONFIG ubuntu@$CONTROLLER_PUBLIC_IP:/tmp/
