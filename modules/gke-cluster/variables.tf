variable "zone_name" {
  type        = string
  default     = "us-central1-c"
  description = "La zone du cluster Kubernetes"
}

variable "cluster_name" {
  type        = string
  default     = "gke-cluster-primary"
  description = "Le nom du cluster Kubernetes"
}

variable "node_type" {
  type        = string
  default     = "e2-micro"
  description = "Le dimensionnement des noeuds du cluster Kubernetes"
}

variable "node_count" {
  type        = number
  default     = 3
  description = "Le nombre de noeuds dans le cluster Kubernetes"
}
