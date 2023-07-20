# Réservation d'une IP externe qui sera spécifiée au niveau de traefik
resource "google_compute_address" "lb_address" {
  name = "lb-address"
}

module "ingress_nginx" {
  source = "../modules/k8s-ingress-nginx"

  load_balancer_ip = google_compute_address.lb_address.address
  dns_domain       = var.dns_domain
}

module "cert_manager" {
  source = "../modules/k8s-cert-manager"
}

module "external_dns" {
  count = var.external_dns_enabled ? 1 : 0

  source             = "../modules/k8s-external-dns"
  cloudflare_api_key = var.cloudflare_api_key
  cloudflare_email   = var.cloudflare_email
  cloudflare_zone_id = var.cloudflare_zone_id
}
