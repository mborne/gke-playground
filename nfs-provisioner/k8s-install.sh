#!/bin/bash

if [ -z "$NFS_SERVER_IP" ];
then
    echo "NFS_SERVER_IP is required!"
    exit 1
fi

# Add helm repository
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/

# Update helm repositories
helm repo update

# Create namespace nfs-provisioner if not exists
kubectl create namespace nfs-provisioner --dry-run=client -o yaml | kubectl apply -f -

# Deploy nfs-subdir-external-provisioner with helm
# see https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner/blob/master/charts/nfs-subdir-external-provisioner/README.md#readme
helm -n nfs-provisioner upgrade --install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=${NFS_SERVER_IP} \
    --set nfs.path=/gke_share \
    --set storageClass.accessModes=ReadWriteMany \
    --set storageClass.name=nfs-legacy


