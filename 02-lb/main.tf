# Réservation d'une IP externe qui sera spécifiée au niveau du déploiement du LB
resource "google_compute_address" "lb_address" {
  name = "lb-address"
}

# Création du namespace cible
resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
}


# Déploiement ingress-nginx avec IP réservée
module "ingress_nginx" {
  source = "../modules/k8s-ingress-nginx"

  namespace_name   = kubernetes_namespace.ingress_nginx.id
  load_balancer_ip = google_compute_address.lb_address.address
}
