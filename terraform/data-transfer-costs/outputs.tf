output "centralized_load_balancer_ip" {
  value = google_compute_global_address.centralized_load_balancer_ip.address
}

output "duplicated_load_balancer_ip" {
  value = google_compute_global_address.duplicated_load_balancer_ip.address
}
