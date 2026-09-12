data "aws_caller_identity" "current" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "random_id" "bucket" {
  byte_length = 4
}

resource "aws_s3_bucket" "assets" {
  bucket = "${var.project}-assets-${data.aws_caller_identity.current.account_id}-${random_id.bucket.hex}"

  # The original DB seed remains recoverable unless the objects are removed explicitly.
  force_destroy = false
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "assets" {
  bucket = aws_s3_bucket.assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "assets" {
  bucket = aws_s3_bucket.assets.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "database_seed" {
  bucket                 = aws_s3_bucket.assets.id
  key                    = "bootstrap/FlaskDB_backup20250520.sql"
  source                 = "${path.module}/../database backup/FlaskDB_backup20250520.sql"
  etag                   = filemd5("${path.module}/../database backup/FlaskDB_backup20250520.sql")
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "app_secrets" {
  bucket                 = aws_s3_bucket.assets.id
  key                    = "bootstrap/secrets.json"
  source                 = "${path.module}/../secrets.json"
  etag                   = filemd5("${path.module}/../secrets.json")
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "prometheus" {
  bucket                 = aws_s3_bucket.assets.id
  key                    = "bootstrap/prometheus.yml"
  source                 = "${path.module}/assets/prometheus.yml"
  etag                   = filemd5("${path.module}/assets/prometheus.yml")
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "grafana_datasource" {
  bucket                 = aws_s3_bucket.assets.id
  key                    = "bootstrap/grafana/datasource.yml"
  source                 = "${path.module}/assets/grafana/datasource.yml"
  etag                   = filemd5("${path.module}/assets/grafana/datasource.yml")
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "grafana_dashboard_provider" {
  bucket                 = aws_s3_bucket.assets.id
  key                    = "bootstrap/grafana/dashboard-provider.yml"
  source                 = "${path.module}/assets/grafana/dashboard-provider.yml"
  etag                   = filemd5("${path.module}/assets/grafana/dashboard-provider.yml")
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "grafana_dashboard" {
  bucket                 = aws_s3_bucket.assets.id
  key                    = "bootstrap/grafana/standard-monitoring.json"
  source                 = "${path.module}/../monitoring/grafana/standard-monitoring-backup.json"
  etag                   = filemd5("${path.module}/../monitoring/grafana/standard-monitoring-backup.json")
  server_side_encryption = "AES256"
}

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "host" {
  name               = "${var.project}-host-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.host.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "host" {
  statement {
    sid = "ReadBootstrapAssets"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]
    resources = ["${aws_s3_bucket.assets.arn}/bootstrap/*"]
  }

  statement {
    sid = "WriteDatabaseBackups"
    actions = [
      "s3:PutObject"
    ]
    resources = ["${aws_s3_bucket.assets.arn}/backups/*"]
  }

  statement {
    sid       = "ReadRuntimeSecret"
    actions   = ["ssm:GetParameter"]
    resources = ["arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter${var.runtime_parameter_name}"]
  }
}

resource "aws_iam_role_policy" "host" {
  name   = "${var.project}-bootstrap"
  role   = aws_iam_role.host.id
  policy = data.aws_iam_policy_document.host.json
}

resource "aws_iam_instance_profile" "host" {
  name = "${var.project}-host-profile"
  role = aws_iam_role.host.name
}

resource "aws_security_group" "host" {
  name        = "${var.project}-host-sg"
  description = "Public Flask and authenticated Grafana; administration through SSM"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Flask application"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.app_cidr]
  }

  ingress {
    description = "Grafana dashboard"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.grafana_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project}-host-sg" }
}

resource "aws_instance" "host" {
  ami                         = data.aws_ssm_parameter.al2023.value
  instance_type               = var.instance_type
  subnet_id                   = sort(data.aws_subnets.default.ids)[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.host.id]
  iam_instance_profile        = aws_iam_instance_profile.host.name

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    region                 = var.region
    bucket                 = aws_s3_bucket.assets.id
    database_seed_key      = aws_s3_object.database_seed.key
    app_secrets_key        = aws_s3_object.app_secrets.key
    prometheus_key         = aws_s3_object.prometheus.key
    grafana_datasource_key = aws_s3_object.grafana_datasource.key
    grafana_provider_key   = aws_s3_object.grafana_dashboard_provider.key
    grafana_dashboard_key  = aws_s3_object.grafana_dashboard.key
    runtime_parameter_name = var.runtime_parameter_name
    docker_image           = var.docker_image
  })

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true
  }

  depends_on = [
    aws_iam_role_policy.host,
    aws_iam_role_policy_attachment.ssm,
    aws_s3_object.database_seed,
    aws_s3_object.app_secrets,
    aws_s3_object.prometheus,
    aws_s3_object.grafana_datasource,
    aws_s3_object.grafana_dashboard_provider,
    aws_s3_object.grafana_dashboard
  ]

  tags = { Name = "${var.project}-single-host" }
}

