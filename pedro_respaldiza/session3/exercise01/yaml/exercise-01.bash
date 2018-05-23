#!/bin/bash

# Exit if an error occurs
set -e

# Generate nameSpaces  
kubectl create -f team-vision-ns.yaml
kubectl create -f team-api-ns.yaml

# Quotas
kubectl create -f team-vision-limits.yaml
kubectl create -f team-api-limits.yaml
