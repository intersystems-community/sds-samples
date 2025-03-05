#!/bin/bash

kubectl create namespace idfs

kubectl create secret docker-registry intersystems-container-registry-secret --docker-server=https://irepo.intersystems.com --docker-username=asamary --docker-password="4CfCta0gEWJhfPzCJQfevIrdsx9H1ZlsyRbBP7AClHYb" --namespace="idfs"
kubectl create secret generic iris-key-secret --from-file=./iris-x86.key --namespace="idfs"

kubectl create secret docker-registry intersystems-container-registry-secret --docker-server=https://containers.intersystems.com --docker-username=asamary --docker-password="4CfCta0gEWJhfPzCJQfevIrdsx9H1ZlsyRbBP7AClHYb" --namespace="default"


