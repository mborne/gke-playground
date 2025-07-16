variable "load_balancer_ip" {
  description = "L'IP du LoadBalancer à réserver en amont"
  nullable    = false
}

variable "load_balancer_hostname" {
  type        = string
  description = "L'entrée DNS pour le LoadBalancer pour configuration de l'annotation external-dns"
  nullable    = false
  default     = "lb-gke.quadtreeworld.net"
}

variable "namespace_name" {
  type        = string
  nullable    = false
  default     = "ingress-nginx"
  description = "Le namespace de déploiement de nginx-ingress-controller"
}

variable "ingress_class_name" {
  type        = string
  nullable    = false
  default     = "nginx"
  description = "Le nom de la ressource IngressClass"
}

variable "chart_version" {
  type        = string
  nullable    = false
  default     = "12.0.0" # https://hub.docker.com/r/bitnamicharts/nginx-ingress-controller/tags
  description = "La version du chart bitnami/nginx-ingress-controller"
}

