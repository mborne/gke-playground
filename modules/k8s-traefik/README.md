# k8s-traefik

Déploiement de Traefik avec le provider helm de Terraform.

## Principe de fonctionnement

[main.tf](main.tf) assure le déploiement en utilisant le fichier [values.yaml](values.yaml)

## Accès au dashboard

```bash
# Pour http://localhost:8888/dashboard/ :
kubectl -n traefik-system port-forward $(kubectl -n traefik-system get pods -o name | head -1) 8888:9000
```
