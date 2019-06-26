# automated-k8s
Create GKE K8s Cluster with Nginx Ingress and deploy a stateless application with script.

Pre-Requisites:
1. GCP Account.
2. gcloud sdk & kubectl should be installed on system.

Steps:
1. Run wrapup.sh in terminal (It will create the cluster, namespace, deploys apps in both namespaces and lastly installs Nginx Ingress Controller.)
2. Add entries in /etc/hosts file as required.
