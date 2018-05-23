#!/bin/bash

source ./common.bash

helm install stable/traefik --name ingress-traefik --namespace kube-system --set rbac.enable=true
