# Assessment

Here we are building and pushing docker :
minikube start
docker build -t yanaabhilasha/app:0.1
docker login
docker run -p 5000:5000 yanaabhilasha/app:0.1
docker push yanaabhilasha/app:0.1

DEPLOYMENT OF OUR APPLICATION ON KUBERNETES
kubectl apply -f manifest.yaml
kubectl get pods
kubectl apply -f service.yaml
minikube service appservice

Deploying AWS Infrastructure with Terraform

terraform init
terraform plan
terraform apply

