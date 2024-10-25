# GCS Bucket for content storage
resource "google_storage_bucket" "cdn_bucket" {
  name     = "${var.project_id}-cdn-bucket"
  location = var.region
}

# Backend Bucket for the CDN
resource "google_compute_backend_bucket" "cdn_backend_bucket" {
  name        = "cdn-backend-bucket"
  bucket_name = google_storage_bucket.cdn_bucket.name
  enable_cdn  = true
}

# URL Map to route requests
resource "google_compute_url_map" "cdn_url_map" {
  name            = "cdn-url-map"
  default_service = google_compute_backend_bucket.cdn_backend_bucket.self_link
}

# Target HTTP Proxy for the CDN
resource "google_compute_target_http_proxy" "cdn_http_proxy" {
  name    = "cdn-http-proxy"
  url_map = google_compute_url_map.cdn_url_map.self_link
}

# Global Forwarding Rule to direct traffic to the CDN
resource "google_compute_global_forwarding_rule" "cdn_forwarding_rule" {
  name       = "cdn-forwarding-rule"
  target     = google_compute_target_http_proxy.cdn_http_proxy.self_link
  port_range = "80"
  ip_address = google_compute_global_address.cdn_ip_address.address
}

# External IP for the CDN
resource "google_compute_global_address" "cdn_ip_address" {
  name = "cdn-ip-address"
}
