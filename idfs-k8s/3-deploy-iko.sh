#!/bin/bash

helm install iko sds2/iris-operator-amd --namespace default --set imagePullSecrets[0].name="intersystems-container-registry-secret"