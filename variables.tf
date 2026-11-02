# VPC and Subnet Variables==================================
variable "my_vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.111.0.0/16"
}
variable "my_subnet_nva_public" {
  description = "The CIDR block for the NVA public subnet"
  type        = string
  default     = "10.111.1.0/24"
}
variable "my_subnet_nva_private" {
  description = "The CIDR block for the NVA private subnet"
  type        = string
  default     = "10.111.2.0/24"
}
variable "my_subnet_a_public" {
  description = "The CIDR block for the public subnet A"
  type        = string
  default     = "10.111.3.0/24"
}

variable "my_subnet_b_public" {
  description = "The CIDR block for the public subnet B"
  type        = string
  default     = "10.111.4.0/24"
}
variable "my_subnet_a_private" {
  description = "The CIDR block for the private subnet A"
  type        = string
  default     = "10.111.5.0/24"
}
variable "my_subnet_b_private" {
  description = "The CIDR block for the private subnet B"
  type        = string
  default     = "10.111.6.0/24"
}



variable "my_tag_name" {
  description = "The name tag for the resources"
  type        = string
  default     = "project1"
}
# S3 bucket variables ===================================================
variable "my_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "my-tf-test-bucket"
}

variable "my_name_tags" {
  description = "The name tag for the S3 bucket"
  type        = string
  default     = "My bucket"
}
variable "my_sg_name" {
  description = "The name of the security group"
  type        = string
  default     = "my-sg"
}
variable "my_sg_description" {
  description = "The description of the security group"
  type        = string
  default     = "Allowing traffic through the security group"
}
# Ec2 instance variables
variable "my_instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "my_ami" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "my_key_name" {
  description = "The key pair name for the EC2 instance"
  type        = string
  default     = "my-key"
}

# security group variables_________________________________________________________
variable "my_ip_address" {
  description = "The IP address allowed to access the security group"
  type        = string
  default     = "99.243.176.120/32"
}
# ALB variables__________________________________________________________________

variable "alb_sg_name" {
  description = "The name of the ALB security group"
  type        = string
  default     = "alb-sg"
}
variable "alb_sg_description" {
  description = "The description of the ALB security group"
  type        = string
  default     = "Allowing traffic through the ALB security group"
}

variable "my_alb_name" {
  description = "The name of the Application Load Balancer"
  type        = string
  default     = "my-alb"
}
variable "my_alb_target_group_name" {
  description = "The name of the ALB target group"
  type        = string
  default     = "my-alb-tg"
}
variable "my_target_port" {
  description = "The port on which the target group will listen"
  type        = number
  default     = 80
}
variable "my_listener_port" {
  description = "The port on which the ALB listener will listen"
  type        = number
  default     = 80
}
variable "my_listener_protocol" {
  description = "The protocol on which the ALB listener will listen"
  type        = string
  default     = "HTTP"
}

# NVA variables
variable "nva_instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t3.micro"
}
