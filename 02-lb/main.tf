# Réservation d'une IP externe qui sera spécifiée au niveau du déploiement du LB
resource "google_compute_address" "lb_address" {
  name = "lb-address"
}

# Création du namespace cible
resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
}


# Déploiement ingress-nginx avec IP réservée
module "ingress_nginx" {
  source = "../modules/k8s-ingress-nginx"

  namespace_name   = kubernetes_namespace.ingress_nginx.id
  load_balancer_ip = google_compute_address.lb_address.address
}

# Déploiement cert-manager
module "cert_manager" {
  source = "../modules/k8s-cert-manager"
}


resource "kubernetes_manifest" "clusterissuer_letsencrypt" {
  count = var.letsencrypt_email != "" ? 1 : 0

  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind" = "ClusterIssuer"
    "metadata" = {
      "name" = "letsencrypt"
    }
    "spec" = {
      "acme" = {
        "email" = var.letsencrypt_email
        "privateKeySecretRef" = {
          "name" = "letsencrypt"
        }
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "solvers" = [
          {
            "http01" = {
              "ingress" = {
                "class" = "nginx"
              }
            }
          },
        ]
      }
    }
  }

  depends_on = [module.cert_manager]
}

