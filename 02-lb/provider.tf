terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=4.65"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.17"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region_name
}

data "google_client_config" "default" {

}

data "google_container_cluster" "primary" {
  name     = var.gke_cluster_name
  location = var.zone_name
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.primary.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  }
}
