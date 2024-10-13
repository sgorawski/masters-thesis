output "fixed_load_balancer_ip" {
  value = google_compute_global_address.fixed_load_balancer_ip.address
}

output "autoscaling_load_balancer_ip" {
  value = google_compute_global_address.autoscaling_load_balancer_ip.address
}
