#!/bin/bash
#Phase 1
sudo yum install -y git
curl -LO https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz
tar -xzf eksctl_* && sudo mv eksctl /usr/local/bin
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl && sudo mv kubectl /usr/local/bin
eksctl create cluster --name otel-cluster --nodes 2 --node-type t3.large --region us-east-1

#Phase 2
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update
kubectl create namespace otel-helm
helm install otel-demo open-telemetry/opentelemetry-demo -n otel-helm

#Phase 3
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090 -n monitoring &
kubectl port-forward svc/prometheus-kube-prometheus-alertmanager 9093:9093 -n monitoring &
aws eks update-kubeconfig --region us-east-1 --name otel-cluster