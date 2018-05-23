# Exercise 2 of session 3: Add a network policie
# Pedro Ignacio Respaldiza Hidalgo (aka Iñaki Respaldiza)
# K8s Training user: pedro_respaldiza

# Exit if an error occurs
set -e

# Create namespace
kubectl create -f exercise-02-ns.yaml

# Create secrets
kubectl create secret generic mariadb-secret  --namespace=exercise-02 --from-literal=dbuser=k8s_wordpress --from-literal=dbname=k8s_wordpress --from-literal=dbpassword=*tjb3yC1T@8t --from-literal=dbrootpassword=Xsdasdfgq2O --from-literal=dbprefix=k8_ -o yaml --dry-run > mariadb-secret.yaml
kubectl create secret generic wordpress-secret --namespace=exercise-02 --from-literal=wppassword=7v9Jq7X#Pg#a -o yaml --dry-run > wordpress-secret.yaml
kubectl create -f mariadb-secret.yaml
kubectl create -f wordpress-secret.yaml

# Create ConfigMap
kubectl create configmap wordpress-cm --namespace=exercise-02 --from-literal=wpuser=k8straining --from-literal=wpname=k8straining -o yaml --dry-run > wordpress-cm.yaml
kubectl create -f wordpress-cm.yaml

# Create services and deployment
kubectl create -f mariadb.yaml
kubectl create -f wordpress.yaml

# Create Network Police
kubectl create -f network-police.yaml

# Create Ingress rule
kubectl create -f wordpress-ingress.yaml

# Add the host name in the /etc/hosts file (the environment variable MY_SANDBOX_IP was added to the .bashrc of my system)
echo "${MY_SANDBOX_IP}   wordpress-exercise-02.com" | sudo tee -a /etc/hosts
