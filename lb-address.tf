# Réservation d'une IP externe qui sera spécifiée au niveau de traefik
resource "google_compute_address" "lb_address" {
  name = "lb-address"
}
