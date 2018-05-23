#!/bin/bash

source ./common.bash

kubectl apply -f calico-node-daemonset.yaml

# install CNI plugin
wget -N -P /opt/cni/bin https://github.com/projectcalico/cni-plugin/releases/download/v3.1.1/calico
wget -N -P /opt/cni/bin https://github.com/projectcalico/cni-plugin/releases/download/v3.1.1/calico-ipam
chmod +x /opt/cni/bin/calico /opt/cni/bin/calico-ipam

mkdir -p /etc/cni/net.d
cat >/etc/cni/net.d/10-calico.conf <<EOF
{
    "name": "calico-k8s-network",
    "cniVersion": "0.6.0",
    "type": "calico",
    "etcd_endpoints": "http://<ETCD_IP>:<ETCD_PORT>",
    "log_level": "info",
    "ipam": {
        "type": "calico-ipam"
    },
    "policy": {
        "type": "k8s"
    },
    "kubernetes": {
        "kubeconfig": "</PATH/TO/KUBECONFIG>"
    }
}
EOF

# CNI loopbak (required)
wget https://github.com/containernetworking/cni/releases/download/v0.6.0/cni-v0.6.0.tgz
tar -zxvf cni-v0.6.0.tgz
sudo cp loopback /opt/cni/bin/

# Deploy Calico-kube-controller
kubectl create -f calico-kube-controllers.yaml

# Calico RBAC
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/rbac.yaml

