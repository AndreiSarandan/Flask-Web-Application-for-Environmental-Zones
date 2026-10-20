output "private_app_route_table_id" {
  description = "Route table of the private-app tier; 30-nat adds the 0.0.0.0/0 -> NAT route here"
  value       = aws_route_table.private["private-app"].id
}

output "private_app_subnet_ids" {
  description = "Subnets for app compute (EC2, ECS, EKS nodes)"
  value       = [for k, s in aws_subnet.this : s.id if var.subnets[k].tier == "private-app"]
}

output "private_data_subnet_ids" {
  description = "Subnets for databases (RDS subnet group)"
  value       = [for k, s in aws_subnet.this : s.id if var.subnets[k].tier == "private-data"]
}

output "public_subnet_ids" {
  description = "Subnets for internet-facing resources (ALB, NAT)"
  value       = [for k, s in aws_subnet.this : s.id if var.subnets[k].tier == "public"]
}

output "vpc_id" {
  description = "ID of the lab VPC"
  value       = aws_vpc.main.id
}
