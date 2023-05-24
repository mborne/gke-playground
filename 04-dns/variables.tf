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

variable "dns_domain" {
  type = string
  #default = "quadtreeworld.net"
  nullable = false
  description = "Domaine pour création des entrées *.gke et lb-gke (doit correspondre à une zone CloudFlare)"
}
