variable "region" {
  description = "AWS region used for the demo deployment."
  type        = string
  default     = "eu-central-1"
}

variable "aws_profile" {
  description = "AWS CLI profile authenticated with temporary credentials."
  type        = string
  default     = "lez-demo"
}

variable "project" {
  description = "Prefix used for AWS resource names and tags."
  type        = string
  default     = "lez-demo"
}

variable "instance_type" {
  description = "2 GB is enough for Flask, MySQL, Prometheus and Grafana for the presentation workload."
  type        = string
  default     = "t3a.small"
}

variable "root_volume_size" {
  description = "Encrypted gp3 root disk containing Docker volumes."
  type        = number
  default     = 24
}

variable "docker_image" {
  description = "Existing private Docker Hub image for the Flask application."
  type        = string
  default     = "andreisarandan900/flask-web-application:flask-app"
}

variable "runtime_parameter_name" {
  description = "Pre-created SSM SecureString containing runtime credentials as JSON."
  type        = string
  default     = "/lez-demo/runtime"
}

variable "app_cidr" {
  description = "Who may open the public Flask application."
  type        = string
  default     = "0.0.0.0/0"
}

variable "grafana_cidr" {
  description = "Who may open Grafana. Keep public only for the short presentation window."
  type        = string
  default     = "0.0.0.0/0"
}

