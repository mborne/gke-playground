service:
  loadBalancerIP: ${load_balancer_ip}
  externalTrafficPolicy: Local
  annotations:
    external-dns.alpha.kubernetes.io/hostname: "lb.${dns_domain}"
    external-dns.alpha.kubernetes.io/ttl: "120" #optional
