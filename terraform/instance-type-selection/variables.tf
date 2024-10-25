variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "availability_zone" {
  description = "AWS availability zone to use for server instances"
  type        = string
  default     = "eu-west-1a"
}

variable "spot_price" {
  description = "The maximum price to pay for the spot instance, in USD/hour"
  type        = string
  default     = "1.50"
}
