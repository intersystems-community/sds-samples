#!/bin/bash

kubectl delete secret intersystems-container-registry-secret --namespace="idfs"
kubectl delete secret iris-key-secret --namespace="idfs"

kubectl delete secret intersystems-container-registry-secret --namespace="default"


