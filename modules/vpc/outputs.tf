output "VPC_ID" {
  value = aws_vpc.main-vpc.id
}
output "SUBNET_NVA_PUBLIC_ID" {
  value = aws_subnet.subnet_nva_public.id
}
output "SUBNET_NVA_PRIVATE_ID" {
  value = aws_subnet.subnet_nva_private.id
}
output "PUBLIC_SUBNET_A_ID" {
  value = aws_subnet.subnet_a_public.id
}
output "PUBLIC_SUBNET_B_ID" {
  value = aws_subnet.subnet_b_public.id
}
output "PRIVATE_SUBNET_A_ID" {
  value = aws_subnet.subnet_a_private.id
}
output "PRIVATE_SUBNET_B_ID" {
  value = aws_subnet.subnet_b_private.id
}
output "INTERNET_GATEWAY_ID" {
  value = aws_internet_gateway.main-igw.id
}
output "PUBLIC_ROUTE_TABLE_ID" {
  value = aws_route_table.public-rt.id
}
output "PRIVATE_ROUTE_TABLE_ID" {
  value = aws_route_table.private-rt.id
}
