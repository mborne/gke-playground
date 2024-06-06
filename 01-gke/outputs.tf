# Génération d'un fichier kubeconfig.yaml
resource "local_file" "kubeconfig" {
  content         = module.gke_cluster.kubeconfig
  filename        = "${path.module}/../output/kubeconfig.yaml"
  file_permission = 0600

  depends_on = [module.gke_cluster.kubeconfig]
}

