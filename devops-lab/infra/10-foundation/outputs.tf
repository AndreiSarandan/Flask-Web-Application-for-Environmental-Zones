output "private_app_route_table_id" {
  description = "Route table of the private-app tier; 30-nat adds the 0.0.0.0/0 -> NAT route here"
  value       = module.network.private_app_route_table_id
}

output "private_app_subnet_ids" {
  description = "Subnets for app compute (EC2, ECS, EKS nodes)"
  value       = module.network.private_app_subnet_ids
}

output "private_data_subnet_ids" {
  description = "Subnets for databases (RDS subnet group)"
  value       = module.network.private_data_subnet_ids
}

output "public_subnet_ids" {
  description = "Subnets for internet-facing resources (ALB, NAT)"
  value       = module.network.public_subnet_ids
}

output "vpc_id" {
  description = "ID of the lab VPC"
  value       = module.network.vpc_id
}
