# module/nfs-server

Création d'un stockage NFS ayant vocation à être utilisé pour fournir un stockage RWX
avec [nfs-subdir-external-provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner).

## Principe de fonctionnement

* [variables.tf](variables.tf) définit les paramètres disponibles
* [main.tf](main.tf) assure la création du server NFS.
* [outputs.tf](outputs.tf) exporte l'IP privée du serveur NFS dans une variable `"ip_address"`

## Ressources

* [registry.terraform.io - Google Provider - filestore_instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/filestore_instance)


