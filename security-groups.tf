# wan_sg - Security group for the WAN interface of pfSense
# lan_sg - Security group for the LAN interface of pfSense
resource "aws_security_group" "wan_sg" {
  name        = "pfsense-wan-sg"
  description = "WAN security group for pfSense"
  vpc_id      = module.the-vpc.VPC_ID
  tags = {
    Name = "pfsense-wan-sg"
  }

  # Allow HTTPS/HTTP management or restrict to your IP range
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_address] # Best practice: restrict to admin CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lan_sg" {
  name        = "pfsense-lan-sg"
  description = "LAN security group for pfSense"
  vpc_id      = module.the-vpc.VPC_ID
  tags = {
    Name = "pfsense-lan-sg"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.my_vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

