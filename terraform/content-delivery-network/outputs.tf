output "origin_load_balancer_ip" {
  value = google_compute_global_address.origin_load_balancer_ip.address
}


output "cdn_ip" {
  value = google_compute_global_address.cdn_ip_address.address
}
