terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=4.65"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region_name
}

data "google_client_config" "provider" {}

# data "google_container_cluster" "my_cluster" {
#   name     = var.gke_cluster_name
#   location = var.zone_name
# }

# provider "kubernetes" {
#   host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
#   token = data.google_client_config.provider.access_token
#   cluster_ca_certificate = base64decode(
#     data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
#   )
# }
