#!/bin/bash

# based on https://docs.microsoft.com/en-us/azure/aks/ssh

# -o create ,delete ,status. shutdown
# -n aks-name
# -g aks-rg
# set your name and resource group

# aks-network-policy-calico-install.bash -n aks-security2020 -g rg-aks -l northeurope -o create

me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

display_usage() { 
	echo "Example of usage:" 
	echo -e "bash $me -n aks-security2020 -g rg-aks -l northeurope -o addssh" 
	echo -e "bash $me -n aks-security2020 -g rg-aks -l northeurope -o removessh"
    echo -e "bash $me -n aks-security2020 -g rg-aks -l northeurope -o start" 
	echo -e "bash $me -n aks-security2020 -g rg-aks -l northeurope -o stop" 
	echo -e "bash $me -n aks-security2020 -g rg-aks -l northeurope -o status" 
	echo -e "bash $me -n aks-security2020 -g rg-aks -l northeurope -o delete" 
	} 

while getopts n:g:o:l: option
do
case "${option}"
in
n) AKS_NAME=${OPTARG};;
g) AKS_RG=${OPTARG};;
o) VM_OPERATION=${OPTARG};;
l) AKS_LOCATION=${OPTARG};;
esac
done


if [ -z "$VM_OPERATION" ]
then
      echo "\$VM_OPERATION is empty"
	  display_usage
	  exit 1
else
      echo "\$AKS_OPERATION is NOT empty"
fi

if [ -z "$AKS_NAME" ]
then
      echo "\$AKS_NAME is empty"
	  display_usage
	  exit 
else
      echo "\$AKS_NAME is NOT empty"
fi

if [ -z "$AKS_RG" ]
then
      echo "\$AKS_RG is empty"
	  display_usage
	  exit 1
else
      echo "\$AKS_RG is NOT empty"
fi

if [ -z "$AKS_LOCATION" ]
then
      echo "\$AKS_LOCATION is empty"
	  display_usage
	  exit 1
else
      echo "\$AKS_LOCATION is NOT empty"
fi



echo "AKS_NAME: $AKS_NAME"
echo "AKS_RG: $AKS_RG"
echo "AKS_LOCATION: $AKS_LOCATION"
echo "VM_OPERATION: $VM_OPERATION"

# get the resource group for VMs
RG_VM_POOL=$(az aks show -g $AKS_RG -n $AKS_NAME --query nodeResourceGroup -o tsv)
az vm list --resource-group $RG_VM_POOL -o table
az vm list-ip-addresses --resource-group $RG_VM_POOL -o table

# generate ssh keys
ssh-keygen -m PEM -t rsa -b 4096 -P "" -f ~/.ssh/aks-ssh


# add ssh public key

if [ "$VM_OPERATION" = "addssh" ] ;
then
VMS=$(az vm list -g $RG_VM_POOL --query "[].name" -o tsv)

for VM in $VMS
do
  echo "add ssh key to $VM"
  az vm user update \
    --resource-group $RG_VM_POOL \
    --name $VM \
    --username azureuser \
    --ssh-key-value ~/.ssh/aks-ssh.pub
done

fi
