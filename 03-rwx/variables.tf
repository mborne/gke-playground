variable "project_id" {
  type        = string
  nullable    = false
  description = "L'identifiant du projet Google Cloud (ex : playground-s-11-946429c5)"
}

variable "region_name" {
  type        = string
  default     = "us-central1"
  description = "La region de déploiement des services (ex : us-central1)"
}

variable "zone_name" {
  type        = string
  default     = "us-central1-c"
  description = "La zone de déploiement des services"
}

variable "gke_cluster_name" {
  type        = string
  default     = "primary"
  description = "Le nom du cluster Kubernetes"
}
