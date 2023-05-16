module "nfs_provisionner" {
  source = "./modules/k8s-nfs-provisioner"

  nfs_server_ip = module.nfs_server.ip_address

  depends_on = [local_file.kubeconfig]
}
