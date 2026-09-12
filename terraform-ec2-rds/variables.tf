variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "aws_profile" {
  type    = string
  default = "lez-demo"
}

variable "project" {
  type    = string
  default = "lez-demo"
}

variable "instance_type" {
  description = "EC2 host for Flask, Prometheus, Grafana and node-exporter."
  type        = string
  default     = "t3.micro"
}

variable "root_volume_size" {
  type    = number
  default = 20
}

variable "db_instance_class" {
  description = "Low-cost Graviton RDS instance; independent of the x86 EC2 architecture."
  type        = string
  default     = "db.t4g.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_name" {
  type    = string
  default = "flask_lez_db_aws"
}

variable "db_username" {
  type    = string
  default = "lezadmin"
}

variable "docker_image" {
  type    = string
  default = "andreisarandan900/flask-web-application:flask-app"
}

variable "app_runtime_parameter_name" {
  description = "SSM SecureString JSON with Flask, Grafana and Docker Hub credentials."
  type        = string
  default     = "/lez-demo/app-runtime"
}

variable "app_cidr" {
  description = "Public audience allowed to use the Flask application."
  type        = string
  default     = "0.0.0.0/0"
}

variable "grafana_cidr" {
  description = "Audience allowed to open authenticated Grafana during the presentation."
  type        = string
  default     = "0.0.0.0/0"
}

