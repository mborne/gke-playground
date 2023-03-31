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

REGION=${REGION:-us-central1}
export TF_VAR_region_name=$REGION
echo "-- REGION=$ZONE"

ZONE=${ZONE:-us-central1-c}
export TF_VAR_zone_name=$ZONE
echo "-- ZONE=$ZONE"


echo "------------------------------------------------------------------------------------------------"
echo "-- Contrôle de l'accès au projet $PROJECT_ID ..."
echo "------------------------------------------------------------------------------------------------"
gcloud projects describe $PROJECT_ID || {
    echo "Fail to run 'gcloud projects describe $PROJECT_ID' (missing 'gcloud auth login'?)"
    exit 1
}


echo "------------------------------------------------------------------------------------------------"
echo "-- Déploiement dans ${PROJECT_ID} avec ZONE=$ZONE et REGION=$REGION ..."
echo "------------------------------------------------------------------------------------------------"

# Pour le stockage de l'état terraform dans un bucket (non traité ici)
# gcloud services enable storage.googleapis.com --project=$PROJECT_ID
# Pour GKE
gcloud services enable container.googleapis.com --project=$PROJECT_ID

terraform init
terraform plan
terraform apply -auto-approve

echo "------------------------------------------------------------------------------------------------"
echo "-- Récupération de l'adresse IP réservée sous le nom 'gke-lb-address' pour traefik ..."
echo "------------------------------------------------------------------------------------------------"
export LB_ADDRESS=$(gcloud compute addresses describe gke-lb-address --format="value(address)" --project=$PROJECT_ID)
echo "-- LB_ADDRESS=${LB_ADDRESS}"




