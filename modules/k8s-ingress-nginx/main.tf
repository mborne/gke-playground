resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "ingress_nginx" {
  name      = "ingress-nginx"
  namespace = kubernetes_namespace.ingress_nginx.id

  repository = "oci://registry-1.docker.io/bitnamicharts/"
  chart      = "nginx-ingress-controller"

  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    load_balancer_ip = var.load_balancer_ip
  })]
}
