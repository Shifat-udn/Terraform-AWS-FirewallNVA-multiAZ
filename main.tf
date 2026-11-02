
# Created VPC with two public and two private subnets
module "the-vpc" {
  source           = "./modules/vpc"
  vpc_cidr         = var.my_vpc_cidr
  subnet_nva_public  = var.my_subnet_nva_public
  subnet_nva_private = var.my_subnet_nva_private
  subnet_a_public  = var.my_subnet_a_public
  subnet_b_public  = var.my_subnet_b_public
  subnet_a_private = var.my_subnet_a_private
  subnet_b_private = var.my_subnet_b_private
  tag_name         = var.my_tag_name
}

# Create EC2 security group module
module "ec2-sg" {
  source = "./modules/security-groups"
  sg_name     = var.my_sg_name
  description = var.my_sg_description
  vpc_id     = module.the-vpc.VPC_ID
  my_ip_address = var.my_ip_address
  vpc_cidr      = var.my_vpc_cidr
}


# Create EC2 instance A module
module "ec2_a" {
  source = "./modules/ec2"
  ami_id        = var.my_ami
  subnet_id     = module.the-vpc.PRIVATE_SUBNET_A_ID
  instance_type = var.my_instance_type
  key_name      = var.my_key_name
  ec2_name     = "my-ec2-instance_a"
  security_group_id = module.ec2-sg.security_group_id
  depends_on = [aws_instance.pfsense_nva]
}

# Create EC2 instance B module
module "ec2_b" {
  source = "./modules/ec2"
  ami_id        = var.my_ami
  subnet_id     = module.the-vpc.PRIVATE_SUBNET_B_ID
  instance_type = var.my_instance_type
  key_name      = var.my_key_name
  ec2_name     = "my-ec2-instance_b"
  security_group_id = module.ec2-sg.security_group_id
  depends_on = [aws_instance.pfsense_nva]
}

# Create ALB module


module "the-alb" {
  source = "./modules/ALB"
  alb_name               = var.my_alb_name
  alb_target_group_name  = var.my_alb_target_group_name
  target_port            = var.my_target_port
  vpc_id                 = module.the-vpc.VPC_ID
  listener_port          = var.my_listener_port
  listener_protocol      = var.my_listener_protocol
  pub_subnet_a_id        = module.the-vpc.PUBLIC_SUBNET_A_ID
  pub_subnet_b_id        = module.the-vpc.PUBLIC_SUBNET_B_ID
  my_ip_address           = var.my_ip_address
  depends_on = [module.ec2_a, module.ec2_b]
}

# Update EC2 security group rules for health checks from the ALB
resource "aws_vpc_security_group_ingress_rule" "alb_health_check" {
  security_group_id = module.ec2-sg.security_group_id
  to_port           = var.my_target_port
  from_port         = var.my_target_port
  ip_protocol       = "tcp"
  referenced_security_group_id = module.the-alb.alb_security_group_id
}

# Attach Instance A
resource "aws_lb_target_group_attachment" "attach_ec2_a" {
  target_group_arn = module.the-alb.alb_target_group_arn
  target_id        = module.ec2_a.EC2_INSTANCE_PRIVATE_IP
  port             = var.my_target_port
}

# Attach Instance B
resource "aws_lb_target_group_attachment" "attach_ec2_b" {
  target_group_arn = module.the-alb.alb_target_group_arn
  target_id        = module.ec2_b.EC2_INSTANCE_PRIVATE_IP
  port             = var.my_target_port
}
