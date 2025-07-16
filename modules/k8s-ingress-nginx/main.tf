resource "helm_release" "ingress_nginx" {
  namespace = var.namespace_name

  name       = var.ingress_class_name
  repository = "oci://registry-1.docker.io/bitnamicharts/"
  chart      = "nginx-ingress-controller"

  version = var.chart_version

  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    load_balancer_ip       = var.load_balancer_ip
    load_balancer_hostname = var.load_balancer_hostname
    ingress_class_name     = var.ingress_class_name
  })]
}
