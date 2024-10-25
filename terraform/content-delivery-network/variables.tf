variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The region where GCP resources will be created"
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "The zone where GCP resources will be created"
  type        = string
  default     = "europe-west1-b"
}

variable "origin_server_count" {
  description = "Number of origin Google Compute instances to create"
  type        = number
  default     = 10
}
