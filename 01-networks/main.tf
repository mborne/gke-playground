resource "google_compute_network" "gke" {
  name                    = "gke"
  auto_create_subnetworks = true
}

resource "google_compute_network" "nfs" {
  name                    = "nfs"
  auto_create_subnetworks = true
}
