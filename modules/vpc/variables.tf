variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default = "10.111.0.0/16"
}

variable "subnet_nva_public" {
  description = "The CIDR block for the NVA public subnet"
  type        = string
  default     = "10.111.1.0/24"
}
variable "subnet_nva_private" {
  description = "The CIDR block for the NVA private subnet"
  type        = string
  default     = "10.111.2.0/24"
}
variable "subnet_a_public" {
  description = "The CIDR block for the public subnet A"
  type        = string
  default = "10.111.3.0/24"
}
variable "subnet_b_public" {
  description = "The CIDR block for the public subnet B"
  type        = string
  default = "10.111.4.0/24"
}
variable "subnet_a_private" {
  description = "The CIDR block for the private subnet A"
  type        = string
  default = "10.111.5.0/24"
}
variable "subnet_b_private" {
  description = "The CIDR block for the private subnet B"
  type        = string
  default = "10.111.6.0/24"
}
variable "tag_name" {
  description = "The name tag for the resources"
  type        = string
  default = "project1"
}