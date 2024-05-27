output "lb_ip" {
  value = google_compute_address.lb_address.address
}
