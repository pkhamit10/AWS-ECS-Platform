variable "name" {
  description = "Prefix used to name security groups."
  type        = string
}

variable "vpc_id" {
  description = "VPC in which to create the security groups."
  type        = string
}