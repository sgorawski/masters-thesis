output "standard_bucket_url" {
  value = google_storage_bucket.standard_bucket.url
}

output "coldline_bucket_url" {
  value = google_storage_bucket.coldline_bucket.url
}

output "archive_bucket_url" {
  value = google_storage_bucket.archive_bucket.url
}
