module "nfs_server" {
  source = "./modules/nfs-server"

  zone_name = var.zone_name
}
