# gke-playground

## Pré-requis

* Installer [gcloud](https://cloud.google.com/sdk/docs/install) (`gcloud --help`)
* Installer [terraform](https://developer.hashicorp.com/terraform/downloads) (`terraform version`)
* Se connecter sur un compte Google Cloud : https://console.cloud.google.com/
* Se connecter avec gcloud :

```bash
gcloud auth login
gcloud auth application-default login
```

## Principe de fonctionnement

* [provider.tf](provider.tf) configure les [modules Terraform](https://registry.terraform.io/browse/providers) :
  * [Google Cloud](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
  * [Kubernetes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
  * [Helm](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)
* [gke-cluster.tf](gke-cluster.tf) créé un cluster Kubernetes **gke-cluster-primary**

Pour la mise en oeuvre RWX :

* [nfs-server.tf](nfs-server.tf) assure la création d'un serveur NFS (**nfs-server**)
* [gke-rwx.tf](gke-rwx.tf) installe [NFS Subdirectory External Provisioner](https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/) pour l'utiliser dans le cluster via la classe de stockage **nfs-legacy**

Pour l'exposition de service en HTTPS :

* [gke-lb.tf](gke-lb.tf) déploie [Traefik](https://github.com/traefik/traefik#overview) en temps que contrôleur ingress avec la classe `traefik` et un résolveur `letsencrypt`.

## Paramétrage

Les paramètres sont spécifiés dans le fichier [variables.tf](variables.tf). Le script [install.sh](install.sh) simplifie le passage et le contrôle des paramètres suivants :

| Nom          | Description                        | Valeur par défaut |
| ------------ | ---------------------------------- | ----------------- |
| `PROJECT_ID` | Identifiant du projet Google Cloud | NA (**requise**)  |

Pour les autres paramètres disponibles, il est possible d'utiliser par exemple :

```bash
export TF_VAR_gke_node_type=e2-micro
export TF_VAR_gke_node_count=5
```

## Utilisation

```bash
# Avec un projet acloudguru
export PROJECT_ID=playground-s-11-946429c5
# Création de l'infrastructure avec terraform
bash install.sh

# Pour inspecter le résultat en ligne de commande :
gcloud container clusters list --project=$PROJECT_ID
gcloud compute addresses list --project=$PROJECT_ID

# Pour configurer kubectl
ZONE=$(gcloud container clusters describe gke-cluster-primary --project=$PROJECT_ID --format="value(location)")
gcloud container clusters get-credentials gke-cluster-primary --project=$PROJECT_ID --zone=$ZONE

# Pour tester le fonctionnement :
kubectl cluster-info
kubectl get nodes
kubectl get namespaces
```

## License

[MIT](LICENSE)

