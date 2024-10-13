# Instance Template
resource "google_compute_instance_template" "autoscaling_instance_template" {
  name         = "autoscaling-instance-template"
  machine_type = "n1-standard-1"

  disk {
    source_image = "debian-cloud/debian-10"
    auto_delete  = true
  }

  network_interface {
    network = "default"
    access_config {}
  }

  tags = ["autoscaling-application-server"]
}

# Instance Group Manager
resource "google_compute_instance_group_manager" "ausoscaling_instance_group_manager" {
  name               = "autoscaling-instance-group-manager"
  base_instance_name = "gcp-server"
  zone               = var.zone
  target_size        = var.autoscaling_initial_size

  version {
    instance_template = google_compute_instance_template.autoscaling_instance_template.self_link_unique
  }

  named_port {
    name = "http"
    port = 80
  }
}

# Autoscaler
resource "google_compute_autoscaler" "autoscaler" {
  name   = "autoscaler"
  target = google_compute_instance_group_manager.ausoscaling_instance_group_manager.self_link
  zone   = var.zone

  autoscaling_policy {
    max_replicas    = var.autoscaling_max_size
    min_replicas    = var.autoscaling_min_size
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}

# Firewall rule to allow HTTP traffic
resource "google_compute_firewall" "autoscaling_firewall" {
  name    = "autoscaling-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = google_compute_instance_template.autoscaling_instance_template.tags
}

# Backend Service for Load Balancer
resource "google_compute_backend_service" "autoscaling_backend_service" {
  name                  = "autoscaling-backend-service"
  load_balancing_scheme = "EXTERNAL"

  backend {
    group = google_compute_instance_group_manager.ausoscaling_instance_group_manager.instance_group
  }
}

# URL Map for Load Balancer
resource "google_compute_url_map" "autoscaling_url_map" {
  name            = "autoscaling-url-map"
  default_service = google_compute_backend_service.autoscaling_backend_service.self_link
}

# HTTP Proxy
resource "google_compute_target_http_proxy" "autoscaling_http_proxy" {
  name    = "autoscaling-http-proxy"
  url_map = google_compute_url_map.autoscaling_url_map.self_link
}

# Load Balancer Forwarding Rule
resource "google_compute_global_forwarding_rule" "autoscaling_http_forwarding_rule" {
  name       = "autoscaling-http-forwarding-rule"
  target     = google_compute_target_http_proxy.autoscaling_http_proxy.self_link
  port_range = "80"
  ip_address = google_compute_global_address.autoscaling_load_balancer_ip.address
}

# Load Balancer IP Address
resource "google_compute_global_address" "autoscaling_load_balancer_ip" {
  name = "autoscaling-load-balancer-ip"
}
