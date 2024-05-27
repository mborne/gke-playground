replicaCount: 2
service:
  loadBalancerIP: ${load_balancer_ip}
  externalTrafficPolicy: Local
ingressClassResource:
  name: ${ingress_class_name}
