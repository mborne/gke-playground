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

* [provider.tf](provider.tf) spécifie l'utilisation du plugin terraform [Google Cloud Platform Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
* [gke-cluster.tf](gke-cluster.tf) définit la création d'un cluster Kubernetes [gke-cluster-primary.tf](gke-cluster-primary.tf)
* [lb-address.tf](lb-address.tf) permet de réserver une IP publique qui pourra spécifiée au niveau du déploiement d'un contrôleur ingress.

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

