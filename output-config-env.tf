resource "local_file" "output_config_env" {
  content = templatefile("${path.module}/templates/config.env.tmpl",
    {
      project_id    = var.project_id,
      zone_name     = var.zone_name,
      region_name   = var.region_name,
      lb_ip_address = google_compute_address.lb_address.address,
      nfs_server_ip = module.nfs_server.ip_address
    }
  )
  filename = "${path.module}/output/config.env"
}
