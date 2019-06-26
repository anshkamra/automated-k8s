gcloud container clusters create assign --zone asia-south1-a --node-locations asia-south1-a --num-nodes 2  --enable-autoscaling --max-nodes=3 --min-nodes=2
gcloud container clusters get-credentials assign --zone asia-south1-a --project secret-robot-218219
kubectl create ns staging
kubectl create ns production
cd /tmp
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > install-helm.sh
chmod u+x install-helm.sh
./install-helm.sh
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
helm install stable/nginx-ingress --name nginx-ingress
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-deployment.yaml -n staging
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-service.yaml -n staging
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-deployment.yaml -n staging
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-service.yaml -n staging
kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-deployment.yaml -n staging
kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-service.yaml  -n staging
kubectl autoscale deployment frontend --cpu-percent=50 --min=1 --max=10 -n staging

kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-deployment.yaml -n production
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-service.yaml -n production
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-deployment.yaml -n production
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-service.yaml -n production
kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-deployment.yaml -n production
kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-service.yaml  -n production
kubectl autoscale deployment frontend --cpu-percent=50 --min=1 --max=10 -n production
