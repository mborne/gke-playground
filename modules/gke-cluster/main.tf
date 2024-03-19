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

  # Création d'un nombre minimal de noeud en vue de créer des pools séparés
  remove_default_node_pool = true
  initial_node_count       = 1

  # logging_service          = "logging.googleapis.com/kubernetes"
  # monitoring_service       = "monitoring.googleapis.com/kubernetes"
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
  }
}


# Création d'un pool de noeud pour le cluster Kubernetes
resource "google_container_node_pool" "default" {
  name       = "default-node-pool"
  location   = var.zone_name
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  node_config {
    preemptible  = false
    machine_type = var.node_type

    service_account = data.google_compute_default_service_account.default.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
