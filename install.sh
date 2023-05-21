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

# Kubernetes Engine API
gcloud services enable container.googleapis.com --project=$PROJECT_ID
# Cloud Filestore API pour le stockage RWX (NFS managé)
gcloud services enable file.googleapis.com --project=$PROJECT_ID


echo "------------------------------------------------------------------------------------------------"
echo "-- Déploiement dans ${PROJECT_ID} ..."
echo "------------------------------------------------------------------------------------------------"

cd 01-gke
terraform init
terraform apply -auto-approve
cd ..

cd 02-rwx
terraform init
terraform apply -auto-approve
cd ..

cd 03-lb
terraform init
terraform apply -auto-approve
cd ..

cd 04-dns
terraform init
terraform apply -auto-approve
cd ..
