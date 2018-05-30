Session 4:
Pedro Ignacio Respaldiza Hidalgo (aka Iñaki Respaldiza)
K8s Training user: pedro_respaldiza
---
Based on previous WordPress exercises, I have implemented an exporter to mariadb to monitor the application. For reasons of time I have not implemented Apache, but I will do it anyway for my work.

You can see the sidecar container in mariabd.yaml and in the deployment and exposure of its ports in the service.

The exercise.bash script deploys both the application and the monitoring system.

GrafanaDashboard.json is a Dashboard to visualize the cluster and mariadb metrics. It is based on the bitnami dashboard that we used in the session, with a pair of windows specific of the database that have been added.

ab.bash displays the container test for kubernetes. The deployment, service and ingress to be able to visit it from outside the cluster.

I am reading the documentation for the alert system, if I have time I will commit it. But, for work reasons, I do not know if I can do it.
