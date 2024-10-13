variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "spot_price" {
  description = "The maximum price to pay for the spot instance, in USD/hour"
  type        = string
  default     = "1.50"
}
