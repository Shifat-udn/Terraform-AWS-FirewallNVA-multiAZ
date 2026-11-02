# Find the latest pfSense Plus AMI ID automatically (or map it explicitly)
# suscribe to the Netgate AWS account to access pfSense Plus AMIs
# You need to have an active subscription to the Netgate AWS account to be able to use these AMIs (t3a.micro-$0.12/Hrs)

data "aws_ami" "pfsense_plus" {
  most_recent = true
  owners      = ["679593333241"] # Netgate's official AWS Marketplace Owner ID

  filter {
    name   = "name"
    values = ["pfSense-plus-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"] # Use "arm64" if you plan to deploy on AWS Graviton instances
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# WAN Interface (eth0)
# 2. Create an Elastic IP
resource "aws_eip" "pfsense_eip" {
  domain = "vpc"

  tags = {
    Name = "pfsense-eip"
  }
}

# 3. Associate the Elastic IP with the EC2 instance
resource "aws_eip_association" "eip_assoc" {
  network_interface_id = aws_network_interface.wan_eni.id
  allocation_id        = aws_eip.pfsense_eip.id
}


resource "aws_network_interface" "wan_eni" {
  subnet_id         = module.the-vpc.SUBNET_NVA_PUBLIC_ID
  security_groups   = [aws_security_group.wan_sg.id]
  source_dest_check = false

  tags = { Name = "pfsense-wan-eni" }
}

# LAN Interface (eth1) - Critical: source_dest_check must be false for an NVA
resource "aws_network_interface" "lan_eni" {
  subnet_id         = module.the-vpc.SUBNET_NVA_PRIVATE_ID
  security_groups   = [aws_security_group.lan_sg.id]
  source_dest_check = false

  tags = { Name = "pfsense-lan-eni" }
}


# pfSense EC2 Instance
resource "aws_instance" "pfsense_nva" {
  ami           = data.aws_ami.pfsense_plus.id
  instance_type = var.nva_instance_type
  key_name      = var.my_key_name
  # Attach WAN as primary interface (eth0)
  primary_network_interface {
    network_interface_id = aws_network_interface.wan_eni.id
  }

  tags = {
    Name = "pfSense-NVA"
  }
    # Source/destination checking is managed on the individual ENIs.
  lifecycle {
    ignore_changes = [source_dest_check]
  }
}
# Attach the LAN interface (device_index 1) explicitly as a separate resource
resource "aws_network_interface_attachment" "lan_attachment" {
  instance_id          = aws_instance.pfsense_nva.id
  network_interface_id = aws_network_interface.lan_eni.id
  device_index         = 1
}

# 2. Output the resolved AMI ID to your terminal
output "latest_pfsense_ami_id" {
  value       = data.aws_ami.pfsense_plus.id
  description = "The latest pfSense Plus AMI ID discovered in this region."
}

resource "aws_route" "public-rt-route" {
  route_table_id         = module.the-vpc.PRIVATE_ROUTE_TABLE_ID #aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.lan_eni.id
}