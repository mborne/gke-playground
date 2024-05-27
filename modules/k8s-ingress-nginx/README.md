# k8s-ingress-nginx

Déploiement de [nginx-ingress-controller](https://bitnami.com/stack/nginx-ingress-controller/helm).

## Principe de fonctionnement

[main.tf](main.tf) assure le déploiement en utilisant le fichier [values.yaml](values.yaml)

## Ressources

* [bitnami/nginx-ingress-controller - parameters](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller/#parameters)
* Use following commands to list available versions :

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm search repo bitnami/nginx-ingress-controller --versions
```
