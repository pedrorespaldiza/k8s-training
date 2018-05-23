
#!/bin/bash

source ./common.bash
echo "Creating kube-apiserver certificates"
export KUBE_APISERVER_CSR_PATH=/tmp/kube-apiserver_server.csr
export KUBE_APISERVER_CERT_CONFIG=/tmp/kube-apiserver_cert_config.conf
scp ubuntu@$CONTROLLER_PUBLIC_IP:$KUBE_APISERVER_CSR_PATH "KUBE_APISERVER_CSR_PATH"
scp ubuntu@$CONTROLLER_PUBLIC_IP:$KUBERNETES_CA_CERT_PATH "$KUBERNETES_CA_CERT_PATH"

# Install kube-apiserver
#

echo "Installing kube-apiserver"

## Download
wget -q "$KUBE_APISERVER_URL" -P "$KUBERNETES_BIN_DIR"
chmod +x "$KUBERNETES_BIN_DIR/kube-apiserver"

## Create systemd service
cat << EOF | sudo tee "$KUBE_APISERVER_SYSTEMD_SERVICE_PATH"
[Unit]
Description=kube-apiserver
[Service]
ExecStart=${KUBERNETES_BIN_DIR}/kube-apiserver \\
  --advertise-address=${INTERNAL_IP} \\
  --allow-privileged=true \\
  --apiserver-count=3 \\
  --audit-log-maxage=30 \\
  --audit-log-maxbackup=3 \\
  --audit-log-maxsize=100 \\
  --audit-log-path=/var/log/audit.log \\
  --authorization-mode=Node,RBAC \\
  --bind-address=0.0.0.0 \\
  --client-ca-file=${KUBERNETES_CA_CERT_PATH} \\
  --enable-admission-plugins=Initializers,NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \\
  --enable-swagger-ui=true \\
  --etcd-cafile=${KUBERNETES_CA_CERT_PATH} \\
  --etcd-certfile=${ETCD_CLIENT_CERT_PATH} \\
  --etcd-keyfile=${ETCD_CLIENT_KEY_PATH} \\
  --etcd-servers=https://${CONTROLLER0_PRIVATE_IP}:2379,https://${CONTROLLER1_PRIVATE_IP}:2379 \\
  --event-ttl=1h \\
  --experimental-encryption-provider-config=/var/lib/kubernetes/encryption-config.yaml \\
  --kubelet-certificate-authority=/var/lib/kubernetes/ca.pem \\
  --kubelet-client-certificate=/var/lib/kubernetes/kubernetes.pem \\
  --kubelet-client-key=/var/lib/kubernetes/kubernetes-key.pem \\
  --kubelet-https=true \\
  --runtime-config=api/all \\
  --service-account-key-file=${SERVICE_ACCOUNT_GEN_CERT_PATH} \\
  --service-cluster-ip-range=${SERVICE_CLUSTERIP_NET} \\
  --service-node-port-range=30000-40000 \\
  --tls-cert-file=${KUBE_APISERVER_CERT_PATH} \\
  --tls-private-key-file=${KUBE_APISERVER_KEY_PATH} \\
  --v=2
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kube-apiserver.service
systemctl restart kube-apiserver.service

# Cleanup
rm /tmp/kube-apiserver* -rf

echo "End of kube-apiserver step"
