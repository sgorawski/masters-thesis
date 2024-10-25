resource "google_storage_bucket" "standard_bucket" {
  name          = "${var.project_id}-standard-bucket"
  location      = var.region
  storage_class = "STANDARD"
}

resource "google_storage_bucket" "coldline_bucket" {
  name          = "${var.project_id}-coldline-bucket"
  location      = var.region
  storage_class = "COLDLINE"
}

resource "google_storage_bucket" "archive_bucket" {
  name          = "${var.project_id}-archive-bucket"
  location      = var.region
  storage_class = "ARCHIVE"
}
