variable "project_id" {
  type     = string
  nullable = false
  description = "L'identifiant du projet Google Cloud (ex : playground-s-11-946429c5)"
}

variable "region_name" {
  type    = string
  default = "us-central1"
  description = "La region de déploiement des services (ex : us-central1)"
}

variable "zone_name" {
  type    = string
  default = "us-central1-c"
  description = "La zone de déploiement des services (ex : us-central1-c)"
}

variable "gke_node_type" {
  type    = string
  default = "e2-medium"
  description = "Le dimensionnement des noeuds du cluster Kubernetes"
}

variable "gke_node_count" {
  type = number
  default = 3
  description = "Le nombre de noeuds dans le cluster Kubernetes"
}
