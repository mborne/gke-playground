# Récupération du compte de service par défaut Compute Engine Service Account pour les noeuds
# (roles/monitoring.metricWriter et roles/logging.logWriter requis, non assignable avec 
# google_project_iam_binding avec acloudguru)
data "google_compute_default_service_account" "default" {
}

# Création du cluster Kubernetes
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone_name
  #network  = "gke"

  deletion_protection = false

  # Utilisation du seul pool de noeud par défaut
  initial_node_count = var.node_count
  # NB : recommandé de le supprimer en règle générale
  remove_default_node_pool = false

  node_config {
    preemptible  = false
    machine_type = var.node_type

    service_account = data.google_compute_default_service_account.default.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
  }
}

