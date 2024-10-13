variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The region where centralized resources will be created"
  type        = string
  default     = "europe-west1"
}


variable "zone" {
  description = "The zone where centralized resources will be created"
  type        = string
  default     = "europe-west1-a"
}
