resource "google_filestore_instance" "nfs_server" {
  name     = "nfs-server"
  location = var.zone_name
  tier     = "STANDARD"

  file_shares {
    capacity_gb = 1024
    name        = "gke_share"
  }

  networks {
    network = "default"
    modes   = ["MODE_IPV4"]
  }
}
