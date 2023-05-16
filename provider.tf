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
      version = ">=2.9"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region_name
}

provider "kubernetes" {
  config_path = "./output/kubeconfig"
}

provider "helm" {
  kubernetes {
    config_path = "./output/kubeconfig"
  }
}
