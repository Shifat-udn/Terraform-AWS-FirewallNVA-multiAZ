# 1. Create the EC2 instance in the specified subnet
resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  user_data    = templatefile("${path.module}/cloud-init.tftpl", {html_content = file("${path.module}/index.html") , hostname_vm = var.ec2_name })
  key_name = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  tags = {
    Name = var.ec2_name
  }
}

/*
# 2. Create an Elastic IP
resource "aws_eip" "app_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.ec2_name}-eip"
  }
}

# 3. Associate the Elastic IP with the EC2 instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.app_server.id
  allocation_id = aws_eip.app_eip.id
}
*/