terraform {
  backend "gcs" {
    #bucket  = "${PROJECT_ID}-tf-state"
    prefix = "terraform/rwx"
  }
}
