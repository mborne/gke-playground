replicaCount: 2
service:
  loadBalancerIP: ${load_balancer_ip}
  externalTrafficPolicy: Local
  annotations:
    external-dns.alpha.kubernetes.io/hostname: ${load_balancer_hostname}
    external-dns.alpha.kubernetes.io/ttl: "120" #optional
ingressClassResource:
  name: ${ingress_class_name}
