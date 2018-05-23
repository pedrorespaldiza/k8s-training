#!/bin/bash

source ./common.bash

export ADMIN_CSR_IN_PATH=/tmp/admin.csr
export ADMIN_CERT_OUT_PATH=/tmp/admin.crt

# Download the generated certificate (NOT THE PROPER WAY)
scp ubuntu@$CONTROLLER_PUBLIC_IP:$ADMIN_CERT_OUT_PATH "$ADMIN_CERT_PATH"
scp ubuntu@$CONTROLLER_PUBLIC_IP:$KUBERNETES_CA_CERT_PATH "$ADMIN_CLUSTER_CA_PATH"

# Add new kubectl context

kubectl config set-cluster k8s-training --certificate-authority=$ADMIN_CLUSTER_CA_PATH --embed-certs=true --server=https://${CONTROLLER_PUBLIC_IP}:6443
kubectl config set-credentials k8s-training-admin --client-certificate=$ADMIN_CERT_PATH --client-key=$ADMIN_KEY_PATH --embed-certs=true
kubectl config set-context k8s-training-admin --cluster=k8s-training --user=k8s-training-admin

# Set new context
kubectl config use-context k8s-training-admin

echo "End of admin kubeconfig step"
