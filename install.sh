#!/bin/bash

hash terraform 2>/dev/null || { echo >&2 "terraform required."; exit 1; }
hash gcloud 2>/dev/null || { echo >&2 "gcloud CLI required."; exit 1; }

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
echo "-- Cloud Storage API (GCS) ..."
gcloud services enable storage-component.googleapis.com --project=$PROJECT_ID


print_block "Prepare bucket for terraform ..."
TF_BUCKET_NAME=${PROJECT_ID}-tf-state
gcloud storage buckets describe gs://${TF_BUCKET_NAME}  --project=$PROJECT_ID || {
    gcloud storage buckets create gs://${TF_BUCKET_NAME} --public-access-prevention  --project=$PROJECT_ID
}


print_block "01-gke ..."
cd 01-gke
terraform init -backend-config="bucket=${TF_BUCKET_NAME}"
terraform apply -auto-approve || {
    echo "failure in 01-gke"
    exit 1
}
cd ..

print_block "02-lb (nginx-ingress-controller) ..."
cd 02-lb
terraform init -backend-config="bucket=${TF_BUCKET_NAME}"
terraform apply -auto-approve|| {
    echo "failure in 02-lb"
    exit 1
}
cd ..

RWX_ENABLED=${RWX_ENABLED:-0}
if [ "$RWX_ENABLED" = "1" ];
then
    print_block "03-rwx (nfs-server & nfs-external-subdir-provider)..."
    cd 03-rwx
    terraform init -backend-config="bucket=${TF_BUCKET_NAME}"
    terraform apply -auto-approve
    cd ..
else
    print_block "03-rwx (nfs-server & nfs-external-subdir-provider) : skipped (RWX_ENABLED=0)"
fi



