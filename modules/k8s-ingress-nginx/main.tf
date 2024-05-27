resource "helm_release" "ingress_nginx" {
  namespace = var.namespace_name

  name       = var.ingress_class_name
  repository = "oci://registry-1.docker.io/bitnamicharts/"
  chart      = "nginx-ingress-controller"
  # https://hub.docker.com/r/bitnamicharts/nginx-ingress-controller/tags
  version    = "11.3.0"

  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    load_balancer_ip   = var.load_balancer_ip
    ingress_class_name = var.ingress_class_name
  })]
}
