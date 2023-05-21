resource "kubernetes_namespace" "whoami" {
  metadata {
    name = "whoami"
  }
}

resource "helm_release" "whoami" {
  name      = "whoami"
  namespace = kubernetes_namespace.whoami.id

  repository = "oci://ghcr.io/mborne/helm-charts"
  chart      = "whoami"
  version    = "0.1.1"

  values = [
    "${file("${path.module}/values.yaml")}"
  ]
}
