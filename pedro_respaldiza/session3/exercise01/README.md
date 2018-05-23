# Exercise 1 of session 3: 
# Pedro Ignacio Respaldiza Hidalgo (aka Iñaki Respaldiza)
# K8s Training user: pedro_respaldiza
---
## Users
I have created and signed the certificates. I have created and introduced the contexts.
To export them I used the following command:
~~~
kubectl config view --minify
~~~
I send you encrypted using gpg with Victor's email (which you shared in Slack) as passphrase
## Groups Roles
In general I have assumed that a user or group should not have permissions that are not indicated. Except in the sre group that I have assumed is an administration group and that it must be able to edit the secrets of all the namespace. It is unnecessary for the correct functioning of the profile but I have decided to test the ClusterRoles and ClusterRoleBinding.
## Limits
I have created the configuration and restrictions of the proposed scenario.
Because Kubernetes do not support limits and quotas expresed in percentage, I searched the sandbox resouces to calculate the absolute values.
~~~
$ nproc
2
$ cat /proc/meminfo | grep MemTotal:
MemTotal:        4049112 kB
~~~
In conclusion, Team-Vision will have a limit of 1.6 Cores and 3.2 GB of RAM while Team-Api will only be able to use 0.4 Cores and 0.8 GB of RAM. The limits are established without sustract the consumption of the system and Kubernetes. In addition, the limit of each Team-Api Pod is greater than that of the full nameSpace. The last two questions give no sense to the configuration, but the exercise continues to be valid as proof of concept.
