resource "kubernetes_namespace" "nfs_provisionner" {
  metadata {
    name = "nfs-provisioner"
  }
}

resource "helm_release" "nfs_provisionner" {
  name      = "nfs-subdir-external-provisioner"
  namespace = kubernetes_namespace.nfs_provisionner.id

  repository = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/"
  chart      = "nfs-subdir-external-provisioner"

  set {
    name  = "nfs.server"
    value = var.nfs_server_ip
  }
  set {
    name  = "nfs.path"
    value = "/gke_share"
  }
  set {
    name  = "storageClass.accessModes"
    value = "ReadWriteMany"
  }
  set {
    name  = "storageClass.name"
    value = "nfs-legacy"
  }
}
