output "ip_address" {
    value = google_filestore_instance.nfs_server.networks.0.ip_addresses.0
}
