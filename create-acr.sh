#!/bin/bash
resourcegroup="app-01-sel-dev-rg"
aks_cluster="luccv-dev-01-aks"
acr="luccvacr202311"
# Change the ACR name in the commands below.
# Assuming the acdnd-c4-project resource group is still available with you
# ACR name should not have upper case letter
az acr create --resource-group ${resourcegroup} --name ${acr} --sku Basic
# Log in to the ACR
az acr login --name ${acr}
# Get the ACR login server name
# To use the azure-vote-front container image with ACR, the image needs to be tagged with the login server address of your registry. 
# Find the login server address of your registry
az acr show --name ${acr} --query loginServer --output table
# Associate a tag to the local image. You can use a different tag (say v2, v3, v4, ....) everytime you edit the underlying image. 
docker tag azure-vote-front:v1 ${acr}.azurecr.io/azure-vote-front:v1
# Now you will see myacr202106.azurecr.io/azure-vote-front:v1 if you run "docker images"
# Push the local registry to remote ACR
docker push ${acr}.azurecr.io/azure-vote-front:v1
# Verify if your image is up in the cloud.
az acr repository list --name ${acr} --output table
# Associate the AKS cluster with the ACR
az aks update -n ${aks_cluster} -g ${resourcegroup} --attach-acr ${acr}

az acr show --name ${acr} --query loginServer --output table
