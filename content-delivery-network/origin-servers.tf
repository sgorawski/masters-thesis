# Google Compute Instances
resource "google_compute_instance" "origin_application_server" {
  count        = var.origin_server_count
  name         = "origin-application-server-${count.index}"
  zone         = var.zone
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  tags = ["origin-application-server"]
}

resource "google_compute_instance_group" "origin_instance_group" {
  name      = "fixed-instance-group"
  zone      = var.zone
  instances = google_compute_instance.origin_application_server[*].self_link
}

# Firewall rule to allow HTTP traffic
resource "google_compute_firewall" "origin_firewall" {
  name    = "origin-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["origin-application-server"]
}

# Health Check
resource "google_compute_health_check" "origin_http_health_check" {
  name               = "origin-http-health-check"
  check_interval_sec = 5
  timeout_sec        = 5

  http_health_check {
    port = 80
  }
}

# Backend Service for Load Balancer
resource "google_compute_backend_service" "origin_backend_service" {
  name                  = "origin-backend-service"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_health_check.origin_http_health_check.self_link]

  backend {
    group = google_compute_instance_group.origin_instance_group.self_link
  }
}

# URL Map for Load Balancer
resource "google_compute_url_map" "origin_url_map" {
  name            = "origin-url-map"
  default_service = google_compute_backend_service.origin_backend_service.self_link
}

# HTTP Proxy
resource "google_compute_target_http_proxy" "origin_http_proxy" {
  name    = "origin-http-proxy"
  url_map = google_compute_url_map.origin_url_map.self_link
}

# Load Balancer Forwarding Rule
resource "google_compute_global_forwarding_rule" "origin_http_forwarding_rule" {
  name       = "origin-http-forwarding-rule"
  target     = google_compute_target_http_proxy.origin_http_proxy.self_link
  port_range = "80"
  ip_address = google_compute_global_address.origin_load_balancer_ip.address
}

# Load Balancer IP Address
resource "google_compute_global_address" "origin_load_balancer_ip" {
  name = "origin-load-balancer-ip"
}
