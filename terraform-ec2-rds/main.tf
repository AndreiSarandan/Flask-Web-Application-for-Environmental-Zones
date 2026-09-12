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

# S3 is only the private transport/backup location for the SQL dump. The live
# database is always the RDS instance below.
resource "aws_s3_bucket" "bootstrap" {
  bucket        = "${var.project}-bootstrap-${data.aws_caller_identity.current.account_id}-${random_id.bucket.hex}"
  force_destroy = false
}

resource "aws_s3_bucket_public_access_block" "bootstrap" {
  bucket = aws_s3_bucket.bootstrap.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bootstrap" {
  bucket = aws_s3_bucket.bootstrap.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "database_seed" {
  bucket                 = aws_s3_bucket.bootstrap.id
  key                    = "bootstrap/FlaskDB_backup20250520.sql"
  source                 = "${path.module}/../database backup/FlaskDB_backup20250520.sql"
  etag                   = filemd5("${path.module}/../database backup/FlaskDB_backup20250520.sql")
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "app_secrets" {
  bucket                 = aws_s3_bucket.bootstrap.id
  key                    = "bootstrap/secrets.json"
  source                 = "${path.module}/../secrets.json"
  etag                   = filemd5("${path.module}/../secrets.json")
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "prometheus" {
  bucket                 = aws_s3_bucket.bootstrap.id
  key                    = "bootstrap/prometheus.yml"
  source                 = "${path.module}/assets/prometheus.yml"
  etag                   = filemd5("${path.module}/assets/prometheus.yml")
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "grafana_datasource" {
  bucket                 = aws_s3_bucket.bootstrap.id
  key                    = "bootstrap/grafana/datasource.yml"
  source                 = "${path.module}/assets/grafana/datasource.yml"
  etag                   = filemd5("${path.module}/assets/grafana/datasource.yml")
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "grafana_dashboard_provider" {
  bucket                 = aws_s3_bucket.bootstrap.id
  key                    = "bootstrap/grafana/dashboard-provider.yml"
  source                 = "${path.module}/assets/grafana/dashboard-provider.yml"
  etag                   = filemd5("${path.module}/assets/grafana/dashboard-provider.yml")
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "grafana_dashboard" {
  bucket                 = aws_s3_bucket.bootstrap.id
  key                    = "bootstrap/grafana/standard-monitoring.json"
  source                 = "${path.module}/assets/grafana/standard-monitoring.json"
  etag                   = filemd5("${path.module}/assets/grafana/standard-monitoring.json")
  server_side_encryption = "AES256"
}

resource "aws_security_group" "app" {
  name        = "${var.project}-app-sg"
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
    description = "Flask application direct port"
    from_port   = 5000
    to_port     = 5000
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

  tags = { Name = "${var.project}-app-sg" }
}

resource "aws_security_group" "database" {
  name        = "${var.project}-db-sg"
  description = "MySQL only from the LEZ EC2 application security group"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "MySQL from Flask host"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project}-db-sg" }
}

resource "aws_db_subnet_group" "database" {
  name       = "${var.project}-db-subnets"
  subnet_ids = sort(data.aws_subnets.default.ids)

  tags = { Name = "${var.project}-db-subnets" }
}

resource "aws_db_instance" "database" {
  identifier = "${var.project}-db"

  engine         = "mysql"
  instance_class = var.db_instance_class

  allocated_storage = var.db_allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true

  db_name                     = var.db_name
  username                    = var.db_username
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.database.name
  vpc_security_group_ids = [aws_security_group.database.id]
  publicly_accessible    = false
  multi_az               = false

  backup_retention_period = 1
  deletion_protection     = true
  skip_final_snapshot     = true

  performance_insights_enabled = false
  monitoring_interval          = 0
  auto_minor_version_upgrade   = true
  apply_immediately            = true

  tags = { Name = "${var.project}-db" }
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

resource "aws_iam_role" "app" {
  name               = "${var.project}-app-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.app.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "app" {
  statement {
    sid = "ReadBootstrapAssets"
    actions = [
      "s3:GetObject"
    ]
    resources = ["${aws_s3_bucket.bootstrap.arn}/bootstrap/*"]
  }

  statement {
    sid       = "WriteDatabaseBackups"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.bootstrap.arn}/backups/*"]
  }

  statement {
    sid       = "ReadApplicationRuntime"
    actions   = ["ssm:GetParameter"]
    resources = ["arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter${var.app_runtime_parameter_name}"]
  }

  statement {
    sid       = "ReadRDSManagedPassword"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_db_instance.database.master_user_secret[0].secret_arn]
  }
}

resource "aws_iam_role_policy" "app" {
  name   = "${var.project}-bootstrap"
  role   = aws_iam_role.app.id
  policy = data.aws_iam_policy_document.app.json
}

resource "aws_iam_instance_profile" "app" {
  name = "${var.project}-app-profile"
  role = aws_iam_role.app.name
}

resource "aws_instance" "app" {
  ami                         = data.aws_ssm_parameter.al2023.value
  instance_type               = var.instance_type
  subnet_id                   = sort(data.aws_subnets.default.ids)[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.app.id]
  iam_instance_profile        = aws_iam_instance_profile.app.name

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    region                     = var.region
    bucket                     = aws_s3_bucket.bootstrap.id
    database_seed_key          = aws_s3_object.database_seed.key
    app_secrets_key            = aws_s3_object.app_secrets.key
    prometheus_key             = aws_s3_object.prometheus.key
    grafana_datasource_key     = aws_s3_object.grafana_datasource.key
    grafana_provider_key       = aws_s3_object.grafana_dashboard_provider.key
    grafana_dashboard_key      = aws_s3_object.grafana_dashboard.key
    app_runtime_parameter_name = var.app_runtime_parameter_name
    db_secret_arn              = aws_db_instance.database.master_user_secret[0].secret_arn
    db_endpoint                = aws_db_instance.database.address
    db_name                    = var.db_name
    docker_image               = var.docker_image
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
    aws_db_instance.database,
    aws_iam_role_policy.app,
    aws_iam_role_policy_attachment.ssm,
    aws_s3_object.database_seed,
    aws_s3_object.app_secrets,
    aws_s3_object.prometheus,
    aws_s3_object.grafana_datasource,
    aws_s3_object.grafana_dashboard_provider,
    aws_s3_object.grafana_dashboard
  ]

  tags = { Name = "${var.project}-app-monitoring" }
}

