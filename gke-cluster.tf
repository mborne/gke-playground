# Création d'un compte de service dédié pour les noeuds
# (recommandé par google)
resource "google_service_account" "default" {
  account_id   = "gke-service-account"
  display_name = "Service Account for GKE"
}

# Création du cluster Kubernetes
resource "google_container_cluster" "primary" {
  name     = "gke-cluster-primary"
  location = var.zone_name

  # Création d'un nombre minimal de noeud en vue de créer des pools séparés
  remove_default_node_pool = true
  initial_node_count       = 1

  addons_config {
    # Activation CSI FileStore pour classe de stockage RWX
    # ATTENTION : Une instance par PVC avec 1To minimum et coût non négligeable.
    gcp_filestore_csi_driver_config {
      enabled = true
    }
  }
}


# Création d'un pool de noeud pour le cluster Kubernetes
resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "default-node-pool"
  location   = var.zone_name
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_node_count

  node_config {
    preemptible  = true
    machine_type = var.gke_node_type

    # Utilisation du compte de service dédié aux noeuds
    service_account = google_service_account.default.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
