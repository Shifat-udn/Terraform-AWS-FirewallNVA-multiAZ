# VPC Configuration
my_vpc_cidr         = "10.110.0.0/16"
my_subnet_nva_public = "10.110.1.0/24"
my_subnet_nva_private = "10.110.2.0/24"
my_subnet_a_public  = "10.110.3.0/24"
my_subnet_b_public  = "10.110.4.0/24"
my_subnet_a_private = "10.110.5.0/24"
my_subnet_b_private = "10.110.6.0/24"
my_tag_name         = "projecty"

# S3 Bucket Configuration
my_bucket_name = "terraform-bucket"
my_name_tags   = "projecty"

# Security Group Configuration
my_sg_name        = "Ec2-sg1"
my_sg_description = "Allowing traffic through the security group"
# EC2 Instance Configuration
my_instance_type = "t3.micro"
my_ami           = "ami-0b6d9d3d33ba97d99"
my_key_name      = "IT-TEST"
my_ip_address    = "96.96.96.96/32"

# ALB Configuration
my_alb_name              = "app-alb"
my_alb_target_group_name = "app-tg"
my_target_port           = 80
my_listener_port         = 80
my_listener_protocol     = "HTTP"

