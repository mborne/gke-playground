output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  value = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}


output "kubeconfig" {
  value = yamlencode({
    apiVersion = "v1"
    kind       = "Config"
    preferences = {
      colors = true
    }
    current-context = google_container_cluster.primary.name
    contexts = [
      {
        name = google_container_cluster.primary.name
        context = {
          cluster   = google_container_cluster.primary.name
          user      = data.google_compute_default_service_account.default.email
          namespace = "default"
        }
      }
    ]
    clusters = [
      {
        name = google_container_cluster.primary.name
        cluster = {
          server                     = "https://${google_container_cluster.primary.endpoint}"
          certificate-authority-data = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
        }
      }
    ]
    users = [
      {
        name = data.google_compute_default_service_account.default.email
        user = {
          exec = {
            apiVersion         = "client.authentication.k8s.io/v1beta1"
            command            = "gke-gcloud-auth-plugin"
            interactiveMode    = "Never"
            provideClusterInfo = true
          }
        }
      }
    ]
  })

  depends_on = [google_container_cluster.primary]
}
