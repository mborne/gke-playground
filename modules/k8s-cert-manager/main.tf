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
