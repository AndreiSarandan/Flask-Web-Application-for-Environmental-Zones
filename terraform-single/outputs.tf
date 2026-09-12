output "instance_id" {
  value = aws_instance.host.id
}

output "public_ip" {
  value = aws_instance.host.public_ip
}

output "app_url" {
  value = "http://${aws_instance.host.public_ip}"
}

output "grafana_url" {
  value = "http://${aws_instance.host.public_ip}:3000"
}

output "assets_bucket" {
  value = aws_s3_bucket.assets.id
}

output "operating_commands" {
  value = {
    start = "aws ec2 start-instances --profile ${var.aws_profile} --region ${var.region} --instance-ids ${aws_instance.host.id}"
    stop  = "aws ec2 stop-instances --profile ${var.aws_profile} --region ${var.region} --instance-ids ${aws_instance.host.id}"
    ssm   = "aws ssm start-session --profile ${var.aws_profile} --region ${var.region} --target ${aws_instance.host.id}"
  }
}

