resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik-system"
  }
}

resource "helm_release" "traefik" {
  name      = "traefik"
  namespace = "traefik-system"

  repository = "https://traefik.github.io/charts/"
  chart      = "traefik"

  values = [
    "${file("${path.module}/values.yaml")}"
  ]

  set {
    name  = "service.spec.loadBalancerIP"
    value = var.load_balancer_ip
  }
}
