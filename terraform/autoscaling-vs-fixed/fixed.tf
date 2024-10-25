# Google Compute Instances
resource "google_compute_instance" "fixed_application_server" {
  count        = var.fixed_server_count
  name         = "fixed-application-server-${count.index}"
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

  tags = ["fixed-application-server"]
}

resource "google_compute_instance_group" "fixed_instance_group" {
  name      = "fixed-instance-group"
  zone      = var.zone
  instances = google_compute_instance.fixed_application_server[*].self_link
}

# Firewall rule to allow HTTP traffic
resource "google_compute_firewall" "fixed_firewall" {
  name    = "fixed-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["fixed-application-server"]
}

# Health Check
resource "google_compute_health_check" "fixed_http_health_check" {
  name               = "fixed-http-health-check"
  check_interval_sec = 5
  timeout_sec        = 5

  http_health_check {
    port = 80
  }
}

# Backend Service for Load Balancer
resource "google_compute_backend_service" "fixed_backend_service" {
  name                  = "fixed-backend-service"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_health_check.fixed_http_health_check.self_link]

  backend {
    group = google_compute_instance_group.fixed_instance_group.self_link
  }
}

# URL Map for Load Balancer
resource "google_compute_url_map" "fixed_url_map" {
  name            = "fixed-url-map"
  default_service = google_compute_backend_service.fixed_backend_service.self_link
}

# HTTP Proxy
resource "google_compute_target_http_proxy" "fixed_http_proxy" {
  name    = "fixed-http-proxy"
  url_map = google_compute_url_map.fixed_url_map.self_link
}

# Load Balancer Forwarding Rule
resource "google_compute_global_forwarding_rule" "fixed_http_forwarding_rule" {
  name       = "fixed-http-forwarding-rule"
  target     = google_compute_target_http_proxy.fixed_http_proxy.self_link
  port_range = "80"
  ip_address = google_compute_global_address.fixed_load_balancer_ip.address
}

# Load Balancer IP Address
resource "google_compute_global_address" "fixed_load_balancer_ip" {
  name = "fixed-load-balancer-ip"
}
