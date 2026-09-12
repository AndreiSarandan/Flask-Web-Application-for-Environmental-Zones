output "instance_id" {
  value = aws_instance.app.id
}

output "public_ip" {
  value = aws_instance.app.public_ip
}

output "app_url" {
  value = "http://${aws_instance.app.public_ip}:5000"
}

output "app_url_port_80" {
  value = "http://${aws_instance.app.public_ip}"
}

output "grafana_url" {
  value = "http://${aws_instance.app.public_ip}:3000"
}

output "rds_identifier" {
  value = aws_db_instance.database.identifier
}

output "rds_endpoint" {
  value = aws_db_instance.database.address
}

output "bootstrap_bucket" {
  value = aws_s3_bucket.bootstrap.id
}

output "operating_commands" {
  value = {
    start_ec2 = "aws ec2 start-instances --profile ${var.aws_profile} --region ${var.region} --instance-ids ${aws_instance.app.id}"
    stop_ec2  = "aws ec2 stop-instances --profile ${var.aws_profile} --region ${var.region} --instance-ids ${aws_instance.app.id}"
    start_rds = "aws rds start-db-instance --profile ${var.aws_profile} --region ${var.region} --db-instance-identifier ${aws_db_instance.database.identifier}"
    stop_rds  = "aws rds stop-db-instance --profile ${var.aws_profile} --region ${var.region} --db-instance-identifier ${aws_db_instance.database.identifier}"
    ssm       = "aws ssm start-session --profile ${var.aws_profile} --region ${var.region} --target ${aws_instance.app.id}"
  }
}

