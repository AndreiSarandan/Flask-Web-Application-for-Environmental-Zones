variable "region" {
  description = "AWS region - must be the SAME region where your existing RDS lives"
  type        = string
  default     = "eu-central-1"
}

variable "project" {
  description = "Name prefix for all resources"
  type        = string
  default     = "flask-autoscale"
}

# NOTE: the CI/CD pipeline (.github/workflows/ci-cd.yml) builds & pushes the
# ':flask-app' tag on every push to migrate-to-aws. Keep this in sync with it.
variable "docker_image" {
  description = "Docker Hub image:tag for the Flask app (must contain /health + ProductionConfig)"
  type        = string
  default     = "andreisarandan900/flask-web-application:flask-app"
}

variable "instance_type" {
  description = "EC2 type for app instances (t3.micro = free tier)"
  type        = string
  default     = "t3.micro"
}

# ---- Existing RDS (NOT created here, only referenced) ----
variable "existing_db_identifier" {
  description = "The identifier (name) of your EXISTING RDS instance, e.g. 'flaskapp-db'"
  type        = string
}

variable "db_password" {
  description = "Password of the RDS master user (needed for the app connection string)"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Override DB name. Leave empty to auto-detect from the RDS instance."
  type        = string
  default     = ""
}

variable "db_username" {
  description = "Override DB user. Leave empty to auto-detect (RDS master username)."
  type        = string
  default     = ""
}

# ---- Docker Hub (private repo auth) ----
variable "dockerhub_username" {
  description = "Docker Hub username (defaults to the repo owner)"
  type        = string
  default     = "andreisarandan900"
}

variable "dockerhub_token" {
  description = "Docker Hub access token / password (from .env DOCKERHUB_TOKEN)"
  type        = string
  sensitive   = true
}

# ---- App ----
variable "secret_key" {
  description = "Flask SECRET_KEY - MUST be identical across all instances or login breaks behind the LB"
  type        = string
  sensitive   = true
}

# ---- Autoscaling ----
variable "asg_min" {
  type    = number
  default = 1
}

variable "asg_max" {
  type    = number
  default = 3
}

variable "asg_desired" {
  type    = number
  default = 1
}

variable "cpu_target" {
  description = "Target average CPU %% that triggers scale out/in (legacy CPU policy, unused once request-count scaling is on)"
  type        = number
  default     = 60
}

# Scale on web traffic instead of CPU: target-tracking on ALBRequestCountPerTarget.
# This is the AVERAGE number of completed requests per healthy target per minute that
# AWS tries to hold. Above it => add instances (up to asg_max), below => remove.
# A single t3.micro saturates at ~25 rps (~1500 req/min) on this app, so a target well
# under that (with headroom) triggers scale-out before the instance pegs at 100% CPU.
variable "requests_per_target" {
  description = "Target ALB requests per target per minute that triggers scale out/in"
  type        = number
  default     = 600
}

# ---- Monitoring ----
# Security group of the standalone monitoring host (baseline i-02ac...) that runs
# the central Prometheus. Prometheus scrapes the ASG instances on :5000 (/metrics)
# and :9100 (node-exporter), so the app SG must allow inbound from this SG.
variable "monitor_security_group_id" {
  description = "SG id of the Prometheus/Grafana monitoring host allowed to scrape the app fleet"
  type        = string
  default     = "sg-05d349d22e421af96"
}

# node-exporter image scraped by Prometheus for per-instance host metrics (CPU saturation).
variable "node_exporter_image" {
  description = "node-exporter container image run on every ASG instance"
  type        = string
  default     = "prom/node-exporter:latest"
}
