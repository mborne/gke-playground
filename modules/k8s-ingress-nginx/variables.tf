variable "load_balancer_ip" {
  description = "L'IP du LoadBalancer à réserver en amont"
  nullable    = false
}

variable "dns_domain" {
  type = string
  nullable = false
  description = "Domaine pour création de l'entrée lb.{dns_domain} ( external-dns.alpha.kubernetes.io/hostname )"
}

