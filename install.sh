#!/bin/bash

print_block () {
    echo "------------------------------------------------------------------------------------------------"
    echo "-- $1"
    echo "------------------------------------------------------------------------------------------------"
}

if [ -z "$PROJECT_ID" ];
then
    echo "PROJECT_ID is required!"
    exit 1
fi
export TF_VAR_project_id=$PROJECT_ID

print_block "Check access to PROJECT_ID=$PROJECT_ID ..."
gcloud projects describe $PROJECT_ID || {
    echo "Fail to run 'gcloud projects describe $PROJECT_ID' (missing 'gcloud auth login'?)"
    exit 1
}

print_block "Activate Google Cloud services"

echo "-- Kubernetes Engine API ..."
gcloud services enable container.googleapis.com --project=$PROJECT_ID
echo "-- Cloud Filestore API (NFS/RWX) ..."
gcloud services enable file.googleapis.com --project=$PROJECT_ID


print_block "01-gke ..."
cd 01-gke
terraform init
terraform apply -auto-approve
cd ..

print_block "02-rwx (nfs-server & nfs-external-subdir-provider)..."
cd 02-rwx
terraform init
terraform apply -auto-approve
cd ..


print_block "03-lb (traefik, cert-manager and external-dns) ..."

LB_OPTS=""
if [ ! -z "$GKE_PLAYGROUND_DOMAIN" ];
then
    echo "-- external-dns : enabled (GKE_PLAYGROUND_DOMAIN=$GKE_PLAYGROUND_DOMAIN)"
    LB_OPTS="-var external_dns_enabled=true"
    LB_OPTS="${LB_OPTS} -var dns_domain=$GKE_PLAYGROUND_DOMAIN"
    LB_OPTS="${LB_OPTS} -var cloudflare_api_key=$CLOUDFLARE_API_KEY"
    LB_OPTS="${LB_OPTS} -var cloudflare_email=$CLOUDFLARE_EMAIL"
    LB_OPTS="${LB_OPTS} -var cloudflare_zone_id=$CLOUDFLARE_ZONE_ID"
else
    echo "-- external-dns : skipped (GKE_PLAYGROUND_DOMAIN is required)"
    LB_OPTS="-var external_dns_enabled=false"
fi

cd 03-lb
terraform init
terraform apply $LB_OPTS -auto-approve 
cd ..


