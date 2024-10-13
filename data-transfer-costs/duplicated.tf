# Compute Instances in different regions
resource "google_compute_instance" "us_instance" {
  name         = "gcp-server-us"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  tags = ["duplicated-http-server"]
}

resource "google_compute_instance" "asia_instance" {
  name         = "gcp-server-asia"
  machine_type = "n1-standard-1"
  zone         = "asia-east1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  tags = ["duplicated-http-server"]
}

resource "google_compute_instance" "europe_instance" {
  name         = "gcp-server-europe"
  machine_type = "n1-standard-1"
  zone         = "europe-west1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  tags = ["duplicated-http-server"]
}

# Firewall rule to allow HTTP traffic
resource "google_compute_firewall" "duplicated_firewall" {
  name    = "duplicated-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["duplicated-http-server"]
}

# Backend Service for Load Balancer
resource "google_compute_backend_service" "duplicated_backend_service" {
  name                  = "duplicated-backend-service"
  load_balancing_scheme = "EXTERNAL"

  backend {
    group = google_compute_instance.us_instance.self_link
  }

  backend {
    group = google_compute_instance.asia_instance.self_link
  }

  backend {
    group = google_compute_instance.europe_instance.self_link
  }
}

# URL Map for Load Balancer
resource "google_compute_url_map" "duplicated_url_map" {
  name            = "duplicated-url-map"
  default_service = google_compute_backend_service.duplicated_backend_service.self_link
}

# HTTP Proxy
resource "google_compute_target_http_proxy" "duplicated_http_proxy" {
  name    = "duplicated-http-proxy"
  url_map = google_compute_url_map.duplicated_url_map.self_link
}

# Load Balancer Forwarding Rule
resource "google_compute_global_forwarding_rule" "duplicated_http_forwarding_rule" {
  name       = "duplicated-http-forwarding-rule"
  target     = google_compute_target_http_proxy.duplicated_http_proxy.self_link
  port_range = "80"
  ip_address = google_compute_global_address.duplicated_load_balancer_ip.address
}

# External IP for Load Balancer
resource "google_compute_global_address" "duplicated_load_balancer_ip" {
  name = "duplicated-load-balancer-ip"
}
