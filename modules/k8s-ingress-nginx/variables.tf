variable "load_balancer_ip" {
  description = "L'IP du LoadBalancer à réserver en amont"
  nullable    = false
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
  default     = "11.0.0"
  description = "La version du chart bitnami/nginx-ingress-controller"
}



