# Réservation d'une IP externe qui sera spécifiée au niveau de traefik
resource "google_compute_address" "lb_address" {
  name = "lb-address"
}

module "traefik" {
  source = "./modules/k8s-traefik"

  load_balancer_ip = google_compute_address.lb_address.address

  depends_on = [local_file.kubeconfig]
}
