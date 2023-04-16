#!/bin/bash

GKE_HOSTNAME=${GKE_HOSTNAME:-gke.quadtreeworld.net}
TRAEFIK_HOSTNAME=traefik.${GKE_HOSTNAME}

if [ -z "$LB_IP_ADDRESS" ];
then
    echo "LB_IP_ADDRESS is required!"
    exit 1
fi

# Add helm repository
helm repo add traefik https://helm.traefik.io/traefik

# Update helm repositories
helm repo update

# Create namespace traefik-system if not exists
kubectl create namespace traefik-system --dry-run=client -o yaml | kubectl apply -f -

# Deploy traefik with helm
helm -n traefik-system upgrade --install traefik traefik/traefik -f values.yaml \
    --set service.spec.loadBalancerIP=${LB_IP_ADDRESS}

# Create IngressRoute with dynamic hostname
cat <<EOF | kubectl -n traefik-system apply -f -
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: dashboard
spec:
  entryPoints:
    - web
    - websecure
  routes:
    - match: Host(\`$TRAEFIK_HOSTNAME\`)
      kind: Rule
      services:
        - name: api@internal
          kind: TraefikService
  tls:
    certResolver: letsencrypt
EOF

