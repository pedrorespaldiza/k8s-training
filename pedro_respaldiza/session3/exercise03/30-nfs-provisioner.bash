#!/bin/bash
helm install stable/nfs-provisioner-server --name nfs-provisioner --namespace kube-system --set storageClass.defaultClass=true
