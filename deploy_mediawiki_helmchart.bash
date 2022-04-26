#!/bin/bash
set -e

echo "debug: Output config before applying eheu2dv1inqbatoraks config"
kubectl config get-contexts

echo "debug: merging aks credentials.."
az aks get-credentials --resource-group dv1_rsg_inqbator_aks --name eheu2dv1inqbatoraks --admin

echo "debug: output of config after merging aks credentials config.."
kubectl config get-contexts

echo "debug: Creating the $(NAMESPACE)-dv1-master namespace IF NOT EXIST"
kubectl get namespace $(NAMESPACE)-dv1-master || kubectl create namespace $(NAMESPACE)-dv1-master

echo "debug: Defining the context for the kubectl client"
kubectl config set-context $(NAMESPACE)-dv1-master --namespace=$(NAMESPACE)-dv1-master  --cluster=eheu2dv1inqbatoraks --user=clusterAdmin_dv1_rsg_inqbator_aks_eheu2dv1inqbatoraks

echo "debug: Setting $(NAMESPACE)-dv1-master context"
kubectl config use-context $(NAMESPACE)-dv1-master

# echo "debug: helm delete $(NAMESPACE)-dv1-release if exists"
helm delete --purge $(NAMESPACE)-dv1-release || echo "Release $(NAMESPACE)-dv1-release does not exist"

#MEDIAWIKI PACKAGED BY BITNAMI HELM CHARTS
helm repo add bitnami https://charts.bitnami.com/bitnami

echo "debug: install $(CHART-NAME) application"
helm upgrade --install --debug $(NAMESPACE)-dv1-release stable/mediawiki --version $(VERSION)

echo "debug: output helm list command to deployments info"
helm list $(NAMESPACE)-dv1-release
