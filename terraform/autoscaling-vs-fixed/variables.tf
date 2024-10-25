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

variable "fixed_server_count" {
  description = "Number of fixed Google Compute instances to create"
  type        = number
  default     = 10
}

variable "autoscaling_initial_size" {
  description = "Initial number of instances for autoscaling"
  type        = number
  default     = 3
}

variable "autoscaling_min_size" {
  description = "Minimum number of instances for autoscaling"
  type        = number
  default     = 1
}

variable "autoscaling_max_size" {
  description = "Maximum number of instances for autoscaling"
  type        = number
  default     = 10
}
