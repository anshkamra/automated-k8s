# automated-k8s
Create GKE K8s Cluster with Nginx and a stateless application with script


**********STAGING**********

# Create a Zonal Cluster with 2 nodes
gcloud container clusters create prac --zone asia-south1-a --node-locations asia-south1-a --num-nodes 2  --enable-autoscaling --max-nodes=3 --min-nodes=2

# Connect to the Kubernetes Cluster
gcloud container clusters get-credentials prac --zone asia-south1-a --project secret-robot-218219

# Create Namespaces
kubectl create ns staging
kubectl create ns production

# Install Nginx Ingress Controller (using Helm)
cd /tmp
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > install-helm.sh
chmod u+x install-helm.sh
./install-helm.sh
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
helm install stable/nginx-ingress --name nginx-ingress

# Create guest-book application for staging
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-deployment.yaml -n staging
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-service.yaml -n staging
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-deployment.yaml -n staging
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-service.yaml -n staging
kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-deployment.yaml -n staging
kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-service.yaml  -n staging

# Set pod auto-scaling
kubectl autoscale deployment frontend --cpu-percent=50 --min=1 --max=10 -n staging

# CPU Load Test for staging application
kubectl run -i --tty load-generator --image=busybox /bin/sh
Hit enter for command prompt
while true; do wget -q -O- http://frontend.staging.svc.cluster.local; done


*********PRODUCTION*********

# Create guest-book application for production
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-deployment.yaml -n production
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-service.yaml -n production
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-deployment.yaml -n production
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-service.yaml -n production
kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-deployment.yaml -n production
kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-service.yaml  -n production

# Set pod auto-scaling
kubectl autoscale deployment frontend --cpu-percent=50 --min=1 --max=10 -n production


# CPU Load Test for production application
kubectl exec -i --tty load-generator --image=busybox /bin/sh
Hit enter for command prompt
while true; do wget -q -O- http://frontend.production.svc.cluster.local; done

=======
Create GKE K8s Cluster with Nginx Ingress Controller and deploy a stateless application with script
>>>>>>> 69c765474b58cf749d88428c1971bc663e41f712
