#! /bin/bash

export ID=`az account show --query id -o json`
export SUBSCRIPTION_ID=`echo $ID | tr -d '"' `

export SP_DATA=`az ad sp show --id "http://$AKS_SERVICE_NAME"`
if [[ SP_DATA = *"appId"* ]]; then
    export PERMISSIONS=`az ad sp credential reset --name "http://$AKS_SERVICE_NAME" -o json`
else
    export PERMISSIONS=`az ad sp create-for-rbac --name "$AKS_SERVICE_NAME" --role "Contributor" --scopes "/subscriptions/$SUBSCRIPTION_ID" -o json`
fi
export CLIENT_ID=`echo $PERMISSIONS | sed -e 's/^.*"appId"[ ]*:[ ]*"//' -e 's/".*//'`
export CLIENT_SECRET=`echo $PERMISSIONS | sed -e 's/^.*"password"[ ]*:[ ]*"//' -e 's/".*//'`

export CLUSTER_INFO=`az aks show --resource-group $AKS_RESOURCE_GROUP --name $AKS_CLUSTER_NAME -o json`
export NODE_RESOURCE_GROUP=`echo $CLUSTER_INFO | sed -e 's/^.*"nodeResourceGroup"[ ]*:[ ]*"//' -e 's/".*//'`

export KUBE_NODES=`kubectl get nodes --show-labels`
if [[ $KUBE_NODES =~ agentpool=([a-zA-Z0-9]+), ]] ; then
    export NODEPOOL = ${BASH_REMATCH[1]}
fi
