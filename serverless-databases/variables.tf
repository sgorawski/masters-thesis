variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
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

# TODO: Decide on that, maybe use some default?
variable "subnet_ids" {
  description = "List of subnet IDs for the databases"
  type        = list(string)
}
