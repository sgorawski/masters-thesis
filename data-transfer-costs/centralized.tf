# Google Compute Instances
resource "google_compute_instance" "centralized_application_server" {
  count        = 3
  name         = "centralized-application-server-${count.index}"
  zone         = var.zone
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  tags = ["centralized-application-server"]
}

# Firewall rule to allow HTTP traffic
resource "google_compute_firewall" "centralized_firewall" {
  name    = "centralized-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["centralized-application-server"]
}

# Backend Service for Load Balancer
resource "google_compute_backend_service" "centralized_backend_service" {
  name                  = "centralized-backend-service"
  load_balancing_scheme = "EXTERNAL"

  dynamic "backend" {
    for_each = google_compute_instance.centralized_application_server[*]
    content {
      group = backend.value.self_link
    }
  }
}

# URL Map for Load Balancer
resource "google_compute_url_map" "centralized_url_map" {
  name            = "centralized-url-map"
  default_service = google_compute_backend_service.centralized_backend_service.self_link
}

# HTTP Proxy
resource "google_compute_target_http_proxy" "centralized_http_proxy" {
  name    = "centralized-http-proxy"
  url_map = google_compute_url_map.centralized_url_map.self_link
}

# Load Balancer Forwarding Rule
resource "google_compute_global_forwarding_rule" "centralized_http_forwarding_rule" {
  name       = "centralized-http-forwarding-rule"
  target     = google_compute_target_http_proxy.centralized_http_proxy.self_link
  port_range = "80"
  ip_address = google_compute_global_address.centralized_load_balancer_ip.address
}

# Load Balancer IP Address
resource "google_compute_global_address" "centralized_load_balancer_ip" {
  name = "centralized-load-balancer-ip"
}
