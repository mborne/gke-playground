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
