# k8s-traefik

Déploiement de traefik avec le provider helm de Terraform.

## Accès au dashboard

```bash
# Pour http://localhost:8888/dashboard/ :
kubectl -n traefik-system port-forward $(kubectl -n traefik-system get pods -o name | head -1) 8888:9000
```
