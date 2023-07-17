resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = "external-dns"
  }
}

resource "kubernetes_service_account" "external_dns" {
  metadata {
    name      = "external-dns"
    namespace = kubernetes_namespace.external_dns.id
  }
}

resource "kubernetes_cluster_role" "external_dns" {
  metadata {
    name = "external-dns"
  }

  rule {
    api_groups = [""]
    resources  = ["services", "pods", "nodes", "endpoints"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking", "networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "external_dns_viewer" {
  metadata {
    name = "external-dns-viewer"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "external-dns"
    namespace = "external-dns"
  }

  depends_on = [kubernetes_service_account.external_dns, kubernetes_cluster_role.external_dns]
}


resource "kubernetes_deployment" "external_dns" {
  metadata {
    name = "external-dns"
    namespace = kubernetes_namespace.external_dns.id
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        test = "external-dns"
      }
    }

    template {
      metadata {
        labels = {
          test = "external-dns"
        }
      }

      spec {
        service_account_name = "external-dns-viewer"
        container {
          image = "registry.k8s.io/external-dns/external-dns:v0.13.5"
          name  = "external-dns"
          args = [
            "--source=service",
            "--source=ingress",
            "--zone-id-filter=${var.cloudflare_zone_id}",
            "--provider=cloudflare",
            "--cloudflare-dns-records-per-page=5000"
          ]
          env {
            CF_API_KEY = var.cloudflare_api_key
            CF_API_EMAIL = var.cloudflare_email
          }
        }
      }
    }
  }
}

# apiVersion: apps/v1
# kind: Deployment
# metadata:
#   name: external-dns
# spec:
#   strategy:
#     type: Recreate
#   selector:
#     matchLabels:
#       app: external-dns
#   template:
#     metadata:
#       labels:
#         app: external-dns
#     spec:
#       serviceAccountName: external-dns
#       containers:
#       - name: external-dns
#         image: registry.k8s.io/external-dns/external-dns:v0.13.5
#         args:
#         - --source=service
#         - --source=ingress
#         - --zone-id-filter=$CLOUDFLARE_ZONE_ID
#         - --provider=cloudflare
#         - --cloudflare-dns-records-per-page=5000 # (optional) configure how many DNS records to fetch per request
#         env:
#         - name: CF_API_KEY
#           value: "$CLOUDFLARE_API_KEY"
#         - name: CF_API_EMAIL
#           value: "$CLOUDFLARE_EMAIL"
