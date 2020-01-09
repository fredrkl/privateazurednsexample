SUBSCRIPTION_ID={our subscript id}

ENVIRONMENT=dev
LOCATION=westeurope #weu
LOCATION_SHORT_NAME=weu

RESOURCE_GROUP_NAME_COMMON="example-$ENVIRONMENT-common-$LOCATION_SHORT_NAME-rg"
RESOURCE_GROUP_NAME_CLUSTER="example-$ENVIRONMENT-cluster-$LOCATION_SHORT_NAME-rg"

VNET_NAME="example-$ENVIRONMENT-cluster-$LOCATION_SHORT_NAME-vnet"
VNET_ID="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP_NAME_CLUSTER/providers/Microsoft.Network/virtualNetworks/$VNET_NAME"

PRIVATE_DNS_DOMAIN_NAME=example-$ENVIRONMENT.elkjop.com
VNET_CIDR=10.142.80.0/20

#!/bin/bash
az account set -s $SUBSCRIPTION_ID

## Cluster resource group
az group create -l $LOCATION -n $RESOURCE_GROUP_NAME_CLUSTER

# Vnet
az network vnet create -g $RESOURCE_GROUP_NAME_CLUSTER \
-n $VNET_NAME \
--address-prefix $VNET_CIDR \

az group create -l $LOCATION -n $RESOURCE_GROUP_NAME_COMMON

# Private Azure DNS
az network dns zone create -g $RESOURCE_GROUP_NAME_COMMON \
   -n $PRIVATE_DNS_DOMAIN_NAME \
  --zone-type Private \
  --resolution-vnets $VNET_ID
