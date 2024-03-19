module "gke_cluster" {
  source = "../modules/gke-cluster"

  zone_name    = var.zone_name
  cluster_name = var.gke_cluster_name
  node_type    = var.gke_node_type
  node_count   = var.gke_node_count
}

resource "local_file" "kubeconfig" {
  content         = module.gke_cluster.kubeconfig
  filename        = "${path.module}/../output/kubeconfig"
  file_permission = 0600

  depends_on = [module.gke_cluster.kubeconfig]
}
