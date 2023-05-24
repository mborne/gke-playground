data "google_compute_address" "lb_address" {
  name = "lb-address"
}

data "cloudflare_zone" "qtw" {
  name = var.dns_domain
}

resource "cloudflare_record" "qtw_gke_wildcard" {
  zone_id = data.cloudflare_zone.qtw.id
  name    = "*.gke"
  value   = "lb-gke.${var.dns_domain}"
  type    = "CNAME"
  ttl     = 3600
  proxied = false
}

resource "cloudflare_record" "qtw_lb_gke" {
  zone_id = data.cloudflare_zone.qtw.id
  name    = "lb-gke"
  value   = data.google_compute_address.lb_address.address
  type    = "A"
  ttl     = 600
  proxied = false
}
