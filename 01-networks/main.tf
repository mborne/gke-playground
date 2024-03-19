resource "google_compute_network" "gke" {
  name                    = "gke-network"
  auto_create_subnetworks = true
}
