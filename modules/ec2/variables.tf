variable "aws_region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0b6d9d3d33ba97d99"
}

variable "subnet_id" {
  description = "The ID of the subnet where the EC2 instance will be launched"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "user_data" {
  description = "User data script for the EC2 instance"
  type        = string
  default     = ""
}
variable "key_name" {
  description = "The name of the key pair to use for the EC2 instance"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID for the EC2 instance"
  type        = string
}
variable "ec2_name" {
  description = "The name tag for the EC2 instance"
  type        = string
  default     = "terraform-ec2"
}
