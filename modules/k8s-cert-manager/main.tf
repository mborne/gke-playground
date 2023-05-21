resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  name      = "cert-manager"
  namespace = kubernetes_namespace.cert_manager.id

  repository = "oci://registry-1.docker.io/bitnamicharts/"
  chart      = "cert-manager"

  set {
    name  = "installCRDs"
    value = true
  }
}


resource "kubernetes_manifest" "clusterissuer_letsencrypt_http" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind" = "ClusterIssuer"
    "metadata" = {
      "name" = "letsencrypt-http"
    }
    "spec" = {
      "acme" = {
        "email" = "admin@quadtreeworld.net"
        "privateKeySecretRef" = {
          "name" = "letsencrypt-http"
        }
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "solvers" = [
          {
            "http01" = {
              "ingress" = {
                "class" = "traefik"
              }
            }
          },
        ]
      }
    }
  }

  depends_on = [ helm_release.cert_manager ]
}
