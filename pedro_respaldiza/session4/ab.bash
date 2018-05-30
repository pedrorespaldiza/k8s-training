#!/bin/bash

set -e

# Create Apache benchmark deployment and service 
kubectl create -f ab.yaml
kubectl create -f ab-ingress.yaml
# add url to /etc/host (the environment variable MY_SANDBOX_IP was added to the .bashrc of my system)

echo "${MY_SANDBOX_IP} ab-exercise.com | sudo tee -a /etc/hosts"
