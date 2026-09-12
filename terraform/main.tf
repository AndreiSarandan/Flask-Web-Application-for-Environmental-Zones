# ============================================================================
#  Reference the EXISTING RDS (created during your earlier migration).
#  Nothing about the database is created or modified here except ONE inbound
#  rule so the new autoscaled instances can reach it. Your data is untouched.
# ============================================================================
data "aws_db_instance" "existing" {
  db_instance_identifier = var.existing_db_identifier
}

# The RDS lives in some VPC/subnets - derive them from its subnet group so the
# ALB + EC2 instances land in the SAME network and can actually reach the DB.
data "aws_db_subnet_group" "existing" {
  name = data.aws_db_instance.existing.db_subnet_group
}

locals {
  vpc_id      = data.aws_db_subnet_group.existing.vpc_id
  subnet_ids  = tolist(data.aws_db_subnet_group.existing.subnet_ids)
  db_host     = data.aws_db_instance.existing.address
  db_port     = data.aws_db_instance.existing.port
  db_name     = var.db_name != "" ? var.db_name : data.aws_db_instance.existing.db_name
  db_user     = var.db_username != "" ? var.db_username : data.aws_db_instance.existing.master_username
}

# Latest Amazon Linux 2023 AMI (no hardcoded AMI id)
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# ============================================================================
#  IAM role for the instances - grants SSM so we can debug remotely
#  (aws ssm start-session / send-command -> docker logs) without SSH keys.
# ============================================================================
data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "app" {
  name_prefix        = "${var.project}-role-"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.app.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "app" {
  name_prefix = "${var.project}-profile-"
  role        = aws_iam_role.app.name
}

# ============================================================================
#  Security groups — layered: internet -> ALB -> app
# ============================================================================
resource "aws_security_group" "alb" {
  name        = "${var.project}-alb-sg"
  description = "ALB: allow HTTP from the internet"
  vpc_id      = local.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app" {
  name        = "${var.project}-app-sg"
  description = "App instances: allow 5000 from the ALB only"
  vpc_id      = local.vpc_id

  ingress {
    description     = "Flask from ALB"
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Central Prometheus (on the monitoring host) scrapes the app's /metrics.
  ingress {
    description     = "Prometheus scrape /metrics (Flask)"
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [var.monitor_security_group_id]
  }

  # Central Prometheus scrapes per-instance host metrics from node-exporter.
  ingress {
    description     = "Prometheus scrape node-exporter"
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    security_groups = [var.monitor_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# NOTE: connectivity to RDS (port 3306) is granted by ONE rule you add MANUALLY on
# the RDS security group, so Terraform never touches your existing DB security group.
# After `apply`, add an inbound rule on the RDS 'default' SG:
#   Type = MySQL/Aurora (3306), Source = the app SG id (see output app_security_group_id).

# ============================================================================
#  Launch Template — install Docker, run the app container pointed at the
#  EXISTING RDS via env vars (matches config.py ProductionConfig).
# ============================================================================
resource "aws_launch_template" "app" {
  name_prefix   = "${var.project}-lt-"
  image_id      = data.aws_ssm_parameter.al2023.value
  instance_type = var.instance_type

  iam_instance_profile {
    arn = aws_iam_instance_profile.app.arn
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app.id]
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tftpl", {
    docker_image = var.docker_image
    secret_key   = var.secret_key
    db_host      = local.db_host
    db_port      = local.db_port
    db_name      = local.db_name
    db_user      = local.db_user
    db_pass      = var.db_password
    secrets_json = file("${path.module}/../secrets.json")
    dockerhub_username = var.dockerhub_username
    dockerhub_token    = var.dockerhub_token
    node_exporter_image = var.node_exporter_image
  }))

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "${var.project}-app" }
  }
}

# ============================================================================
#  Application Load Balancer + target group (health-checks /health)
# ============================================================================
resource "aws_lb" "app" {
  name               = "${var.project}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = local.subnet_ids
}

resource "aws_lb_target_group" "app" {
  name     = "${var.project}-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  health_check {
    path                = "/health"
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 15
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# ============================================================================
#  Auto Scaling Group + target-tracking policy on ALB request count per target.
#  This is the "autoscaling": requests/target above requests_per_target => add
#  instances (up to max). Traffic-driven scaling reacts to load directly and does
#  not depend on the CPU alarm winning a race against the health check.
# ============================================================================
resource "aws_autoscaling_group" "app" {
  name                      = "${var.project}-asg"
  min_size                  = var.asg_min
  max_size                  = var.asg_max
  desired_capacity          = var.asg_desired
  vpc_zone_identifier       = local.subnet_ids
  target_group_arns         = [aws_lb_target_group.app.arn]
  # EC2 (not ELB) health: a CPU-saturated instance whose /health momentarily times out
  # must NOT be terminated mid-load — otherwise the ASG recycles it before the scale-out
  # policy can add capacity (the churn loop). ALB still stops routing to unhealthy targets
  # (fail-open when none are healthy); ASG only replaces genuinely dead VMs.
  health_check_type         = "EC2"
  health_check_grace_period = 300 # boot + dnf install docker + image pull can take a few min on t3.micro

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project}-app"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "requests" {
  name                   = "${var.project}-requests-target"
  autoscaling_group_name = aws_autoscaling_group.app.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      # resource_label ties the metric to THIS ALB + target group:
      #   app/<alb-name>/<alb-id>/targetgroup/<tg-name>/<tg-id>
      resource_label = "${aws_lb.app.arn_suffix}/${aws_lb_target_group.app.arn_suffix}"
    }
    target_value = var.requests_per_target
  }
}
