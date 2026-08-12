output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_app_subnet_ids" {
  description = "IDs of private application subnets"
  value       = [for subnet in aws_subnet.private_app : subnet.id]
}

output "private_db_subnet_ids" {
  description = "IDs of private database subnets"
  value       = [for subnet in aws_subnet.private_db : subnet.id]
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_ids" {
  description = "IDs of NAT Gateways"
  value       = [for nat in aws_nat_gateway.main : nat.id]
}