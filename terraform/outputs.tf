output "alb_url" {
  description = "Public URL of the load balancer - use this as Locust --host"
  value       = "http://${aws_lb.app.dns_name}"
}

output "rds_endpoint" {
  description = "The existing RDS endpoint the instances connect to (for sanity check)"
  value       = local.db_host
}

output "asg_name" {
  description = "Auto Scaling Group name (watch it scale during the load test)"
  value       = aws_autoscaling_group.app.name
}

output "app_security_group_id" {
  description = "Add an inbound MySQL(3306) rule on your RDS SG with THIS as the source"
  value       = aws_security_group.app.id
}
