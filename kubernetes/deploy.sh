#!/bin/bash
kubectl apply -f namespace.yml
kubectl apply -f backend_cluster_ip.yml
kubectl apply -f backend_deploy.yml
kubectl apply -f backend_ingress.yml
kubectl apply -f frontend_deploy.yml
kubectl apply -f config_map.yml
kubectl apply -f frontend_cluster_ip.yml
kubectl apply -f frontend_ingress.yml
