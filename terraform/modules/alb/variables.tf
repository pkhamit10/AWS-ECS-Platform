variable "name" {
  description = "Prefix used to name load balancer resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC for the target group."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnets for the ALB."
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group attached to the ALB."
  type        = string
}
