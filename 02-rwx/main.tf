module "nfs_server" {
  source = "../modules/nfs-server"

  zone_name = var.zone_name
}

module "nfs_provisionner" {
  source = "../modules/k8s-nfs-provisioner"

  nfs_server_ip = module.nfs_server.ip_address
}
