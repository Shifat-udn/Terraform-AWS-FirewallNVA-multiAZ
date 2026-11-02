output "EC2_INSTANCE_ID" {
  value = aws_instance.app_server.id
}  
output "EC2_INSTANCE_PUBLIC_IP" {
  value = aws_instance.app_server.public_ip
}
output "EC2_INSTANCE_PRIVATE_IP" {
  value = aws_instance.app_server.private_ip
}


