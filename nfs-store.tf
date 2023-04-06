# Création d'un stockage NFS ayant vocation à être utilisé pour fournir un stockage RWX
# avec https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/filestore_instance
resource "google_filestore_instance" "nfs_instance" {
  name = "nfs-instance"
  location = var.zone_name
  tier = "STANDARD"

  file_shares {
    capacity_gb = 1024
    name        = "share1"
  }

  networks {
    network = "default"
    modes   = ["MODE_IPV4"]
  }
}

output "nfs_instance_ip" {
  value = "${google_filestore_instance.nfs_instance.networks.0.ip_addresses.0}"
  description = "The private IP address of the NFS instance"

  depends_on = [
    google_filestore_instance.nfs_instance
  ]
}
