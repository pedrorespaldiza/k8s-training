#!/bin/bash
# Create Certs
kubectl create secret generic kubernetes-dashboard-certs --from-file=$HOME/certs -n kube-system
# Deploy the Dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
