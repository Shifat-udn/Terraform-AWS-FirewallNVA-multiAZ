variable "sg_name" {
     type = string
     description = "The name of the security group"
}
variable "description" {
     type = string
     description = "Allowing traffic through the security group"
}
variable "vpc_id" {
     type = string
     description = "The ID of the VPC where the security group will be created"
}
variable "vpc_cidr" {
     type = string
     description = "The CIDR block of the VPC where the security group will be created"
}
variable "my_ip_address" {
     type = string
     description = "The IP address allowed to access the security group"
}
