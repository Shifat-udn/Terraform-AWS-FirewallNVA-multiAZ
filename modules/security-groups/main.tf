# Create the Security Group container
resource "aws_security_group" "Ec2-sg1"{
  name        = var.sg_name
  description = var.description
  vpc_id      = var.vpc_id

  tags = {
    Name = var.sg_name
  }
}

# Inbound Rule: Managed as an external resource
resource "aws_vpc_security_group_ingress_rule" "http" {

  security_group_id = aws_security_group.Ec2-sg1.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = var.my_ip_address
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.Ec2-sg1.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.my_ip_address
}

resource "aws_vpc_security_group_ingress_rule" "icmp" {
  security_group_id = aws_security_group.Ec2-sg1.id
  from_port         = -1
  to_port           = -1
  ip_protocol       = "icmp"
  cidr_ipv4         = var.vpc_cidr
}



# Outbound Rule: Managed as an external resource
resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.Ec2-sg1.id
  ip_protocol       = "-1" # All traffic
  cidr_ipv4         = "0.0.0.0/0"
}