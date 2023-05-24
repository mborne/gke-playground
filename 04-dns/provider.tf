terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=4.65"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region_name
}

provider "cloudflare" {
  # CLOUDFLARE_API_KEY
  # api_token = var.cloudflare_api_token
}

