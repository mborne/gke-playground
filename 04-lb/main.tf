# Réservation d'une IP externe qui sera spécifiée au niveau du déploiement du LB
resource "google_compute_address" "lb_address" {
  name = "lb-address"
}

# Déploiement ingress-nginx avec IP réservée
module "ingress_nginx" {
  source = "../modules/k8s-ingress-nginx"

  load_balancer_ip = google_compute_address.lb_address.address
}

# Déploiement cert-manager
module "cert_manager" {
  source = "../modules/k8s-cert-manager"
}
