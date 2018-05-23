#!/bin/bash

source ./common.bash

export ETCD_SERVER_CSR_PATH=/tmp/etcd_server.csr
export ETCD_SERVER_CERT_CONFIG=/tmp/etcd_cert_config.conf

scp ubuntu@$CONTROLLER_PUBLIC_IP:$KUBELET_CERT_OUT_PATH "$KUBELET_CERT_PATH"
scp ubuntu@$CONTROLLER_PUBLIC_IP:$KUBERNETES_CA_CERT_PATH "$KUBERNETES_CA_CERT_PATH"
export ETCD_CLIENT_CSR_PATH=/tmp/etcd_client.csr

## Private key
openssl genrsa -out "$ETCD_CLIENT_KEY_PATH" 2048

## Certificate sign request
openssl req -new -key "$ETCD_CLIENT_KEY_PATH" -out "$ETCD_CLIENT_CSR_PATH" -subj "/CN=etcd-client/O=etcd"

## Certificate
openssl x509 -req -in "$ETCD_CLIENT_CSR_PATH" -CA "$KUBERNETES_CA_CERT_PATH" -CAkey "$KUBERNETES_CA_KEY_PATH" -CAcreateserial -out "$ETCD_CLIENT_CERT_PATH" -days 500

#
# Install etcd
#

echo "Installing etcd"

## Download and extract
wget -q "$ETCD_TARBALL_URL" -P /tmp
tar xf "/tmp/$ETCD_TARBALL_NAME" -C /tmp

## Move the binaries to the installation directory
sudo mv /tmp/etcd-v${ETCD_VERSION}-linux-amd64/etcd* "$ETCD_BIN_DIR"

## Create systemd service
cat << EOF | sudo tee $ETCD_SYSTEMD_SERVICE_PATH
[Unit]
Description=etcd
Documentation=https://github.com/coreos
[Service]
ExecStart=${ETCD_BIN_DIR}/etcd \\ 
  --name ${HOSTNAME} \\
  --cert-file=${ETCD_SERVER_CERT_PATH} \\
  --peer-cert-file=${ETCD_SERVER_CERT_PATH} \\
  --key-file=${ETCD_SERVER_KEY_PATH} \\
  --peer-key-file=${ETCD_SERVER_KEY_PATH} \\
  --trusted-ca-file=${KUBERNETES_CA_CERT_PATH} \\
  --peer-trusted-ca-file=${KUBERNETES_CA_CERT_PATH} \\
  --client-cert-auth \\
  --peer-client-cert-auth \\
  --initial-advertise-peer-urls https://${CONTROLLER1_PRIVATE_IP}:2380 \\
  --listen-peer-urls https://${CONTROLLER1_PRIVATE_IP}:2380 \\
  --advertise-client-urls https://${CONTROLLER1_PRIVATE_IP}:2379,https://127.0.0.1:2379 \\
  --listen-client-urls https://${CONTROLLER1_PRIVATE_IP}:2379,https://127.0.0.1:2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster controller-0=https://${CONTROLLER0_PRIVATE_IP}:2380,controller-1=https://${CONTROLLER1_PRIVATE_IP}:2180 \\
  --initial-cluster-state new \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable etcd.service
systemctl restart etcd.service

# Cleanup
rm /tmp/etcd* -rf

echo "End of etcd step"
