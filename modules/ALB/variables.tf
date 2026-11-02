# Variables for the Application Load Balancer (ALB) module
variable "alb_name" {
  description = "The name of the Application Load Balancer"
  type        = string
}

variable "pub_subnet_a_id" {
  description = "The ID of the public subnet A"
  type        = string
}

variable "pub_subnet_b_id" {
  description = "The ID of the public subnet B"
  type        = string
}

# Variables for the ALB target group and related settings
variable "alb_target_group_name" {
  description = "The name of the ALB target group"
  type        = string
}
variable "target_port" {
  description = "The port on which the target group will receive traffic"
  type        = number
  default     = 80
}
variable "vpc_id" {
  description = "The ID of the VPC where the ALB and target group will be created"
  type        = string
}
# Listener settings for the ALB
variable "listener_port" {
  description = "The port on which the ALB listener will listen"
  type        = number
  default     = 80
}
variable "listener_protocol" {
  description = "The protocol on which the ALB listener will listen"
  type        = string
  default     = "HTTP"
}
variable "my_ip_address" {
  description = "The IP address allowed to access the ALB"
  type        = string
  default     = "0.0.0.0/0"
}
