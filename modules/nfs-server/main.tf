# Création d'un stockage NFS ayant vocation à être utilisé pour fournir un stockage RWX
# avec https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/filestore_instance
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
