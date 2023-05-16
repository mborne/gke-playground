#!/bin/bash

echo "------------------------------------------------------------------------------------------------"
echo "-- Contrôle des paramètres ..."
echo "------------------------------------------------------------------------------------------------"

if [ -z "$PROJECT_ID" ];
then
    echo "PROJECT_ID is required!"
    exit 1
fi
export TF_VAR_project_id=$PROJECT_ID
echo "-- PROJECT_ID=$PROJECT_ID"


echo "------------------------------------------------------------------------------------------------"
echo "-- Contrôle de l'accès au projet $PROJECT_ID ..."
echo "------------------------------------------------------------------------------------------------"
gcloud projects describe $PROJECT_ID || {
    echo "Fail to run 'gcloud projects describe $PROJECT_ID' (missing 'gcloud auth login'?)"
    exit 1
}
echo "------------------------------------------------------------------------------------------------"
echo "-- Activation des services Google Cloud ..."
echo "------------------------------------------------------------------------------------------------"

# Pour le stockage de l'état terraform dans un bucket
gcloud services enable storage.googleapis.com --project=$PROJECT_ID
# Kubernetes Engine API
gcloud services enable container.googleapis.com --project=$PROJECT_ID
# Cloud Filestore API pour le stockage RWX (NFS managé)
gcloud services enable file.googleapis.com --project=$PROJECT_ID

#------------------------------------------------------------------------
# Création du bucket de stockage de l'état terraform s'il n'existe pas
# (variables non autorisées dans backend.bucket)
#------------------------------------------------------------------------
BUCKET_NAME=${PROJECT_ID}-tf-state
gcloud storage buckets describe gs://${BUCKET_NAME} || {
    gcloud storage buckets create gs://${BUCKET_NAME} --public-access-prevention --project=$PROJECT_ID
}

sleep 5

echo "------------------------------------------------------------------------------------------------"
echo "-- Déploiement dans ${PROJECT_ID} ..."
echo "------------------------------------------------------------------------------------------------"

terraform init -backend-config="bucket=${PROJECT_ID}-tf-state"
terraform plan
terraform apply -auto-approve

echo "------------------------------------------------------------------------------------------------"
echo "-- Export de la configuration"
echo "------------------------------------------------------------------------------------------------"
echo "# output/config.env :"
cat output/config.env

echo "------------------------------------------------------------------------------------------------"
echo "-- Utilisation du cluster :"
echo "------------------------------------------------------------------------------------------------"
echo "source output/config.env"
source output/config.env

# echo 'gcloud container clusters get-credentials gke-cluster-primary --project=$PROJECT_ID --zone=$ZONE'
# gcloud container clusters get-credentials gke-cluster-primary --project=$PROJECT_ID --zone=$ZONE

export KUBECONFIG=$PWD/output/kubeconfig
echo 'kubectl get nodes'
kubectl get nodes

