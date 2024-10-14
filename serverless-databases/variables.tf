variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_storage_gb" {
  description = "Storage size for the RDS database, in GB"
  type        = number
  default     = 1000 # 1 TB
}
