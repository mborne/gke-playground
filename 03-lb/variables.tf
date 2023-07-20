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
  type        = string
  default     = "gke.cluster.local"
  description = "Domaine pour création de l'entrée lb.{dns_domain} via l'annotation external-dns.alpha.kubernetes.io/hostname"
}

variable "external_dns_enabled" {
  type        = bool
  default     = false
  description = "Active le déploiement de external-dns"
}

variable "cloudflare_api_key" {
  type        = string
  default     = ""
  description = "CLOUDFLARE_API_KEY"
}

variable "cloudflare_email" {
  type        = string
  default     = ""
  description = "CLOUDFLARE_EMAIL"
}

variable "cloudflare_zone_id" {
  type        = string
  default     = ""
  description = "CLOUDFLARE_ZONE_ID"
}

