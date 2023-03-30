variable "project_id" {
  type     = string
  nullable = false
}

variable "region_name" {
  type    = string
  default = "us-central1"
}

variable "zone_name" {
  type    = string
  default = "us-central1-a"
}

variable "gke_machine_type" {
  type    = string
  default = "e2-medium"
}
