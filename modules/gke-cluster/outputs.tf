data "google_client_config" "default" {
  depends_on = [google_container_cluster.primary]
}

output "kubeconfig" {
  value = yamlencode({
    apiVersion      = "v1"
    kind            = "Config"
    current-context = var.cluster_name
    clusters = [{
      name = var.cluster_name
      cluster = {
        certificate-authority-data = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
        server                     = google_container_cluster.primary.endpoint
      }
    }]
    contexts = [{
      name = var.cluster_name
      context = {
        cluster = var.cluster_name
        user    = var.cluster_name
      }
    }]
    users = [{
      name = var.cluster_name
      user = {
        token = data.google_client_config.default.access_token
      }
    }]
  })
}

# resource "local_file" "kubeconfig" {
#   content  = local.kubeconfig
#   filename = "${path.module}/kubeconfig"
# }