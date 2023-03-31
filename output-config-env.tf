resource "local_file" "output_config_env" {
  content = templatefile("${path.module}/templates/config.env.tmpl",
    {
      project_id = var.project_id,
      zone_name  = var.zone_name,
      region_name  = var.region_name,
      lb_ip_address = google_compute_address.lb_address.address
    }
  )
  filename = "${path.module}/output/config.env"

  depends_on = [google_compute_address.lb_address]
}
